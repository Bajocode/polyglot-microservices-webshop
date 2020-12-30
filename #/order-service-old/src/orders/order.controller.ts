import {Controller, Post, Body, Get, Param, Delete} from '@nestjs/common';
import {InjectRepository} from '@nestjs/typeorm';
import OrderEntity from './order.entity';
import OrderItemEntity from './order-item.entity';
import {Repository} from 'typeorm';
import {CreateOrderDto} from './order.dto';
import Order from './order.interface';

@Controller('orders')
export default class OrderController {
  public constructor(
    @InjectRepository(OrderEntity)
    private readonly orderRepo: Repository<OrderEntity>,
    @InjectRepository(OrderItemEntity)
    private readonly itemRepo: Repository<OrderItemEntity>,
  ) {}

  @Post()
  public async create(@Body() dto: CreateOrderDto): Promise<Order> {
    const order = (({userId, total}) => ({userId, total}))(dto);
    const orderDb = await this.orderRepo.save(this.orderRepo.create(order));
    const items = dto.orderItems.map((i) => ({...i, orderId: orderDb.orderId}));
    const itemsDb = await this.itemRepo.save(items);

    return {...orderDb, orderItems: itemsDb};
  }

  @Get()
  public findAll(): Promise<OrderEntity[]> {
    return this.orderRepo.find();
  }

  @Get(':orderId')
  public async findOne(@Param('orderId') id: string): Promise<Order> {
    const order = await this.orderRepo.findOne(id);
    const orderItems = await this.itemRepo.find({where: {orderId: id}});
    return {...order, orderItems};
  }

  @Delete(':orderId')
  public async remove(@Param('orderId') id: string): Promise<void> {
    this.orderRepo.delete(id);
  }
}
