import OrderController from './order.controller';
import {Repository} from 'typeorm';
import OrderEntity from './order.entity';
import OrderItemEntity from './order-item.entity';

describe('OrderController', () => {
  let sut: OrderController;
  let orderRepo: Repository<OrderEntity>;
  let itemRepo: Repository<OrderItemEntity>;

  beforeEach(() => {
    orderRepo = new Repository();
    itemRepo = new Repository();
    sut = new OrderController(orderRepo, itemRepo);
  });

  describe('findAll', () => {
    it('returns an orders array', async () => {
      const result = [new OrderEntity()];

      jest.spyOn(orderRepo, 'find').mockResolvedValue(result);

      expect(await sut.findAll()).toBe(result);
    });
  });
});
