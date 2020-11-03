import {IsString, IsNumber} from 'class-validator';
import Order from '../orders/Order';

export class CreateOrderDto implements Order {
  @IsString()
  public userid: string;

  @IsNumber()
  public price: number;
}

export class UpdateOrderDto implements Order {
  @IsString()
  public orderid: string;

  @IsString()
  public userid: string;

  @IsNumber()
  public price: number;
}
