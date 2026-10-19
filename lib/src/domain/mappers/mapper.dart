// Use this abstract class to implement a mapper. A mapper is a class that converts DTOs to domain objects and vice versa.
abstract class Mapper<FROM, TO> {
  TO call(FROM object);
}
