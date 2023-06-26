abstract class GenericDao<T, ID> {
  Future<T> save(T data);
  Future<ID> update(T data);
  Future<bool> delete(ID id);
  Future<T> read(ID id);
  Future<List<T>> readAll();
}