import { Test, TestingModule } from '@nestjs/testing';
import { AddressesService } from '../src/modules/addresses/addresses.service';
import { PrismaService } from '../src/config/prisma.service';

describe('AddressesService', () => {
  let service: AddressesService;
  let prisma: any;

  beforeEach(async () => {
    prisma = {
      address: {
        findMany: jest.fn(),
        findUnique: jest.fn(),
        create: jest.fn(),
        update: jest.fn(),
        updateMany: jest.fn(),
        delete: jest.fn(),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AddressesService,
        { provide: PrismaService, useValue: prisma },
      ],
    }).compile();

    service = module.get<AddressesService>(AddressesService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('findAll', () => {
    it('should return user addresses', async () => {
      prisma.address.findMany.mockResolvedValue([
        { id: '1', label: 'Home', addressLine1: '123 Main St' },
      ]);

      const result = await service.findAll('user1');
      expect(Array.isArray(result)).toBe(true);
    });
  });

  describe('create', () => {
    it('should create address', async () => {
      prisma.address.updateMany.mockResolvedValue([]);
      prisma.address.create.mockResolvedValue({
        id: '1', label: 'Home', addressLine1: '123 Main St',
      });

      const result = await service.create('user1', {
        label: 'Home', addressLine1: '123 Main St', postalCode: '380001',
        latitude: 23.0225, longitude: 72.5714, phone: '+919876543210',
      });
      expect(result).toHaveProperty('id');
    });
  });
});
