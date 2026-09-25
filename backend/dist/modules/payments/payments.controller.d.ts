import { PaymentsService } from './payments.service';
export declare class PaymentsController {
    private paymentsService;
    constructor(paymentsService: PaymentsService);
    createOrder(body: {
        orderId: string;
        amount: number;
    }): Promise<{
        orderId: string;
        amount: number;
        currency: string;
        keyId: string | undefined;
    }>;
    verifyPayment(body: {
        orderId: string;
        razorpayOrderId: string;
        razorpayPaymentId: string;
        razorpaySignature: string;
    }): Promise<{
        verified: boolean;
    }>;
    webhook(req: any): Promise<{
        received: boolean;
    }>;
}
