import {Module} from '@nestjs/common';
import {TypeOrmModule} from '@nestjs/typeorm';
import OrderEntity from './order.entity';
import OrderItemEntity from './order-item.entity';
import OrderController from './order.controller';

@Module({
  imports: [
    TypeOrmModule.forFeature([OrderEntity, OrderItemEntity]),
  ],
  controllers: [
    OrderController,
  ],
})
export default class OrderModule {}
