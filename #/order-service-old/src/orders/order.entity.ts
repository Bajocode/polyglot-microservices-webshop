import {Column, Entity, PrimaryGeneratedColumn} from 'typeorm';

@Entity({
  name: 'orders',
})
export default class OrderEntity {
  @PrimaryGeneratedColumn( // implicit: primary, unique, not-null
      'uuid',
      {name: 'order_id'},
  )
  public orderId: string;

  @Column({
    name: 'user_id',
    type: 'uuid',
    primary: false,
    unique: false,
    nullable: false,
  })
  public userId: string;

  @Column({
    name: 'total',
    type: 'integer',
    primary: false,
    unique: false,
    nullable: false,
  })
  public total: number;
}
