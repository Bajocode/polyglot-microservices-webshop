import {Module} from '@nestjs/common';
import {TypeOrmModule} from '@nestjs/typeorm';
import CatalogController from './CatalogController';
import ProductEntity from './ProductEntity';

@Module({
  imports: [TypeOrmModule.forFeature([ProductEntity])],
  controllers: [CatalogController],
})
export default class CatalogModule {}
