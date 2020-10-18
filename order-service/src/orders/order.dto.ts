import OrderItemEntity from './order-item.entity';

export class CreateOrderDto {
  public readonly userId: string;
  public readonly total: number;
  public readonly orderItems: OrderItemEntity[];
}
