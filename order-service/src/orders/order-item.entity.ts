import {Column, Entity, ManyToOne, JoinColumn} from 'typeorm';
import OrderEntity from './order.entity';

@Entity({
  name: 'order_items',
})
export default class OrderItemEntity {
  @ManyToOne(
      () => OrderEntity,
      {
        onDelete: 'CASCADE',
      },
  )
  @JoinColumn({
    name: 'order_id',
    referencedColumnName: 'orderId',
  })
  public order: OrderEntity;

  @Column({
    name: 'order_id',
    type: 'uuid',
    primary: true, // composite
    unique: false,
    nullable: false,
  })
  public orderId: string;

  @Column({
    name: 'product_id',
    type: 'uuid',
    primary: true, // composite
    unique: false,
    nullable: false,
  })
  public productId: string;

  @Column({
    name: 'quantity',
    type: 'integer',
    primary: false,
    unique: false,
    nullable: false,
  })
  public quantity: number;

  @Column({
    name: 'price',
    type: 'integer',
    primary: false,
    unique: false,
    nullable: false,
  })
  public price: number;
}
