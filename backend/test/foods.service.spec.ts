import { Test, TestingModule } from '@nestjs/testing';
import { FoodsService } from '../src/modules/foods/foods.service';
import { PrismaService } from '../src/config/prisma.service';

describe('FoodsService', () => {
  let service: FoodsService;
  let prisma: any;

  beforeEach(async () => {
    prisma = {
      foodItem: {
        findMany: jest.fn(),
        findUnique: jest.fn(),
        create: jest.fn(),
        update: jest.fn(),
        delete: jest.fn(),
        count: jest.fn(),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        FoodsService,
        { provide: PrismaService, useValue: prisma },
      ],
    }).compile();

    service = module.get<FoodsService>(FoodsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('findAll', () => {
    it('should return paginated foods', async () => {
      prisma.foodItem.findMany.mockResolvedValue([
        {
          id: '1', name: 'Paneer Tikka', price: 250, isVeg: true,
          originalPrice: null, rating: 4.5,
          customizationGroups: [
            { id: 'g1', name: 'Spice Level', items: [{ id: 'i1', name: 'Mild', additionalPrice: 0 }] },
          ],
        },
      ]);
      prisma.foodItem.count.mockResolvedValue(1);

      const result = await service.findAll({ skip: 0, take: 10 });
      expect(Array.isArray(result)).toBe(true);
      expect(result.length).toBe(1);
    });
  });

  describe('findOne', () => {
    it('should return a food item', async () => {
      prisma.foodItem.findUnique.mockResolvedValue({
        id: '1', name: 'Paneer Tikka', price: 250,
        customizationGroups: [],
      });

      const result = await service.findOne('1');
      expect(result).toHaveProperty('name', 'Paneer Tikka');
    });

    it('should throw NotFoundException for missing item', async () => {
      prisma.foodItem.findUnique.mockResolvedValue(null);
      await expect(service.findOne('nonexistent')).rejects.toThrow();
    });
  });
});
