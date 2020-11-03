interface CrudStoring<T> {
  create(obj: T): Promise<T>;
  readAll(): Promise<T[]>;
  readById(id: string): Promise<T>;
  update(id: string, obj: T): Promise<T>;
  delete(id: string): Promise<void>;
}

export default CrudStoring;
