import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  User _userMeta = User(
      id: "12222",
      role: "parent",
      name: "Глухарь",
      phoneNumber: '+7 (900) 993-45-76',
      fullName: 'Глухарев Глухарь Глухарьевич',
      birthday: '03.06.2000',
      gender: 'Мужчина',
      children: [
        User(
            id: "12223",
            name: "Иван",
            fullName: 'Иванов Иван Иванович',
            birthday: '03.06.2000',
            gender: 'Мужчина',
            age: 12,
            country: "Россия",
            city: "Москва",
            registration_date: '03.06.2022',
            passport: Passport()),
        User(
            id: "12224",
            name: "Иван",
            fullName: 'Иванов Иван Иванович',
            birthday: '03.06.2000',
            gender: 'Мужчина',
            age: 11,
            country: "Россия",
            city: "Москва",
            registration_date: '03.06.2022',
            passport: Passport()),
      ],
      age: 24,
      country: "Россия",
      city: "Москва",
      registration_date: '03.06.2022',
      passport: Passport());
  // List<Dot> _filteredDots = [];

  // void setUser(List<String> filters) {
  //   _categories = filters;
  //   notifyListeners();
  // }

  // void setData(UserType user) {
  //   _user = user;
  //   notifyListeners();
  // }

  /// Removes all items from the cart.
  void removeAll() {
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  User get user => _userMeta;
}

class Passport {
  String? birthday;
  String? fio;

  String? phoneNumber;

  String? sport_school;

  String? vedomstvo;

  String? trainer;

  String? place_of_training;

  String? tech_qualification;

  String? sport_qualification;

  int? height;

  int? weight;

  String? region;

  String? city;

  String? address;

  String? school;

  String? med_spravka_date;

  String? strah_date;

  // FATHER
  String? father_fio;
  String? father_phoneNumber;
  String? father_birthday;
  String? father_email;

  // MOTHER
  String? mother_fio;
  String? mother_birthday;
  String? mother_phoneNumber;
  String? mother_email;
  Passport(
      {this.birthday,
      this.fio = 'Бондаренко Дмитрий Михайлович',
      this.phoneNumber = '+7 (911) 345-12-78',
      this.sport_school = 'СК “Грандмастер”',
      this.vedomstvo = 'Отсутствует',
      this.trainer = 'Иванов Иван Иванович',
      this.place_of_training = 'Батайск,  МБОУ СОШ №16',
      this.tech_qualification = '9 гып',
      this.sport_qualification = 'Отсутствует',
      this.height = 138,
      this.weight = 26,
      this.region = 'Ростовская область',
      this.city = 'Ростов-на-Дону',
      this.address = 'Ул. Таганрогская, д.32, кв. 29',
      this.school = 'Батайск,  МБОУ СОШ №16',
      this.med_spravka_date = '10.08.2022',
      this.strah_date = '10.08.2022',
      this.father_fio = 'Иванов Иван Иванович',
      this.father_birthday = '12.06.2000',
      this.father_phoneNumber = '+7 (911) 345-12-78',
      this.father_email = 'mail@mail.ru',
      this.mother_fio = 'Иванова Галина Петровна',
      this.mother_birthday = '12.06.2000',
      this.mother_phoneNumber = '+7 (911) 345-12-78',
      this.mother_email = 'mail@mail.ru'});
}

class User {
// Role role = Role.user
//
// switch ( role){
//   case (Role.user): break;
// };
  final id;
  final fullName;
  final phoneNumber;
  final gender;
  // final role = Role;
  final birthday;
  final role;
  final age;
  final country;
  final city;
  final name;
  final registration_date;
  final List<User> children;
  Passport passport;

  User(
      {required this.id,
      required this.fullName,
      this.phoneNumber,
      children,
      this.role,
      // this.role = 'guest',
      this.gender,
      this.birthday,
      this.name,
      required this.age,
      required this.country,
      required this.city,
      this.registration_date,
      required this.passport})
      : children = children ?? [];
}
