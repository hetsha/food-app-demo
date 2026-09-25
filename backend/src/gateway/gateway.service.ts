import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  OnGatewayConnection,
  OnGatewayDisconnect,
  ConnectedSocket,
  MessageBody,
} from '@nestjs/websockets';
import { Logger, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { Server, Socket } from 'socket.io';

@WebSocketGateway({
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
    credentials: true,
  },
  namespace: '/',
  transports: ['websocket', 'polling'],
})
export class OrderGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private readonly logger = new Logger(OrderGateway.name);

  private readonly connectedClients = new Map<string, { userId: string; role: string }>();

  constructor(
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {}

  async handleConnection(client: Socket): Promise<void> {
    try {
      const token =
        client.handshake.auth?.token ||
        client.handshake.query?.token ||
        client.handshake.headers?.authorization?.replace('Bearer ', '');

      if (!token) {
        this.logger.warn(`Client ${client.id} connected without token — disconnecting`);
        client.disconnect();
        return;
      }

      const payload = this.jwtService.verify(token as string);
      const userId: string = payload.sub ?? payload.userId ?? payload.id;
      const role: string = payload.role ?? 'user';

      client.data = { userId, role };
      this.connectedClients.set(client.id, { userId, role });

      this.logger.log(`Client connected: ${client.id} (user: ${userId}, role: ${role})`);
    } catch (error) {
      this.logger.warn(`Client ${client.id} failed authentication — disconnecting`);
      client.disconnect();
    }
  }

  handleDisconnect(client: Socket): void {
    const clientData = this.connectedClients.get(client.id);
    if (clientData) {
      this.logger.log(
        `Client disconnected: ${client.id} (user: ${clientData.userId})`,
      );
    } else {
      this.logger.log(`Client disconnected: ${client.id}`);
    }
    this.connectedClients.delete(client.id);
  }

  @SubscribeMessage('join_order_room')
  handleJoinOrderRoom(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { orderId: string },
  ): { event: string; data: { success: boolean; orderId: string } } {
    const room = `order_${data.orderId}`;
    client.join(room);

    this.logger.log(`Client ${client.id} joined room ${room}`);

    return {
      event: 'joined_order_room',
      data: { success: true, orderId: data.orderId },
    };
  }

  @SubscribeMessage('leave_order_room')
  handleLeaveOrderRoom(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { orderId: string },
  ): { event: string; data: { success: boolean; orderId: string } } {
    const room = `order_${data.orderId}`;
    client.leave(room);

    this.logger.log(`Client ${client.id} left room ${room}`);

    return {
      event: 'left_order_room',
      data: { success: true, orderId: data.orderId },
    };
  }

  emitOrderStatusUpdate(
    orderId: string,
    status: string,
    data: Record<string, unknown> = {},
  ): void {
    const room = `order_${orderId}`;
    this.server.to(room).emit('order_status_update', {
      orderId,
      status,
      timestamp: new Date().toISOString(),
      ...data,
    });

    this.logger.log(`Emitted order_status_update to room ${room}: ${status}`);
  }

  emitNewOrderAlert(chefId: string, order: Record<string, unknown>): void {
    const room = `chef_${chefId}`;
    this.server.to(room).emit('new_order', {
      order,
      timestamp: new Date().toISOString(),
    });

    this.logger.log(`Emitted new_order alert to chef ${chefId}`);
  }

  broadcastToAdmins(event: string, data: Record<string, unknown>): void {
    this.server.to('admins').emit(event, {
      ...data,
      timestamp: new Date().toISOString(),
    });

    this.logger.log(`Broadcast ${event} to admins`);
  }

  joinChefRoom(client: Socket, chefId: string): void {
    const room = `chef_${chefId}`;
    client.join(room);
    this.logger.log(`Client ${client.id} joined chef room ${room}`);
  }

  joinAdminRoom(client: Socket): void {
    client.join('admins');
    this.logger.log(`Client ${client.id} joined admins room`);
  }

  getClientsByUserId(userId: string): Socket[] {
    const sockets: Socket[] = [];
    this.connectedClients.forEach((data, clientId) => {
      if (data.userId === userId) {
        const socket = this.server.sockets.sockets.get(clientId);
        if (socket) {
          sockets.push(socket);
        }
      }
    });
    return sockets;
  }
}
