abstract class ModelConverter<O, D> {
  D to(O model);
  O from(D data);
}