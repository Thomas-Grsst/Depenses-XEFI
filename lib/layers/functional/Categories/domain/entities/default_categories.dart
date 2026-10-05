import 'category.dart';

const defaultCategories = [
  Category(key: 'log', name: 'Logement', shortName: 'Logem.', icon: 'home', colorIndex: 0),
  Category(key: 'ali', name: 'Alimentation', shortName: 'Alim.', icon: 'food', colorIndex: 1),
  Category(key: 'tra', name: 'Transport', shortName: 'Transp.', icon: 'car', colorIndex: 2),
  Category(key: 'loi', name: 'Loisirs', shortName: 'Loisirs', icon: 'film', colorIndex: 3),
  Category(key: 'san', name: 'Santé', shortName: 'Santé', icon: 'heart', colorIndex: 4),
  Category(key: Category.otherKey, name: 'Autres', shortName: 'Autres', icon: 'dots', colorIndex: 5),
];
