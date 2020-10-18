import {Entity, PrimaryGeneratedColumn, Column} from 'typeorm';

@Entity('products')
export default class ProductEntity {
  @PrimaryGeneratedColumn('uuid')
  public productId: string;

  @Column({
    type: 'varchar',
    length: 255,
    unique: true,
    nullable: false,
  })
  public name: string;

  @Column({
    type: 'numeric',
    precision: 2,
    nullable: false,
  })
  public price: number;
}
