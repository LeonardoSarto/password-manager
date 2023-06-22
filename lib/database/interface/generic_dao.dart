abstract class GenericDao<T, ID> {
  Future<T> save(T data);
  Future<T> update(T data);
  Future<bool> delete(ID id);
  Future<T> read(ID id);
  Future<List<T>> readAll();
}