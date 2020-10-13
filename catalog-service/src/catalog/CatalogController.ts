import {Controller, Get, Param, Post, Body} from '@nestjs/common';
import {InjectRepository} from '@nestjs/typeorm';
import {Repository} from 'typeorm';
import {CreateProductDto} from './dto';
import ProductEntity from './ProductEntity';

@Controller('catalog')
export default class CatalogController {
  public constructor(
    @InjectRepository(ProductEntity)
    private readonly repo: Repository<ProductEntity>) {}

  @Get('products')
  public async getProducts(): Promise<ProductEntity[]> {
    return this.repo.find();
  }

  @Get('products/:id')
  public async getProduct(@Param('id') id: string): Promise<ProductEntity> {
    return this.repo.findOne(id);
  }

  @Post('products')
  public async createProduct(@Body() dto: CreateProductDto) {
    const product = await this.repo.create(dto);
    await this.repo.save(product);
    return product;
  }
}
