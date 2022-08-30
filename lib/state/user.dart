import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grandmaster/utils/dio.dart';
import 'package:intl/intl.dart';

class UserState extends ChangeNotifier {
  User _user = User(
    role: 'guest',
    passport: Passport(),
  );

  int? _childId = null;

  // List<Dot> _filteredDots = [];

  // void setUser(List<String> filters) {
  //   _categories = filters;
  //   notifyListeners();
  // }

  // void setData(UserType user) {
  //   _user = user;
  //   notifyListeners();
  // }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  String getRole(String contact_type) {
    switch (contact_type) {
      case 'PARENT':
        return 'sportsmen';
      case 'CLIENT':
        return 'sportsmen';
      case 'PARTNER':
        return 'trainer';
      case 'MODERATOR':
        return 'moderator';
      default:
        return 'guest';
    }
  }

  Future<User> getUser(id) async {
    var response = await createDio().get('/users/${id}/');
    return convertMapToUser(response.data[0]);
  }

  User convertMapToUser(Map data) {
    print(data);
    return User(
        id: data["id"],
        parents: data["parents"],
        chatId: data["dm"],
        children: <MinimalUser>[
          ...data["children"]
              .map((e) => MinimalUser(
                    fullName: e["full_name"],
                    id: e["id"],
                  ))
              .toList()
        ],
        documentsUrl: data["documents"],
        photo: data["photo"],
        admitted: data["admitted"],
        firstName: data["first_name"],
        middleName: data["middle_name"],
        lastName: data["last_name"],
        fullName: data["full_name"] ??
            '${data["first_name"]} ${data["middle_name"] ?? ''}${data["middle_name"] != null ? ' ' : ''}${data["last_name"]}',
        // age: calculateAge(DateTime.parse(data["birth_date"])),
        birthday: data["birth_date"] != null
            ? DateTime.parse(data["birth_date"])
            : null,
        role: getRole(data["contact_type"]),
        country: 'Россия',
        gender: data["gender"],
        city: data["city"],
        passport: Passport(
          fio: data["full_name"] ??
              '${data["first_name"]} ${data["middle_name"] ?? ''}${data["middle_name"] != null ? ' ' : ''}${data["last_name"]}',
          birthday: data["birth_date"] != null
              ? DateFormat("dd.MM.y").format(DateTime.parse(data["birth_date"]))
              : null,
          phoneNumber: data["phone_number"],
          sport_school: data["sport_school"],
          school: data["school"],
          region: data["region"],
          tech_qualification: data["tech_qualification"],
          sport_qualification: data["sport_qualification"],
          address: data["address"],
          med_spravka_date: data["med_certificate_date"] != null
              ? DateFormat("dd.MM.y")
                  .format(DateTime.parse(data["med_certificate_date"]))
              : null,
          strah_date: data["insurance_policy_date"] != null
              ? DateFormat("dd.MM.y")
                  .format(DateTime.parse(data["insurance_policy_date"]))
              : null,
          father_birthday: data["father_birth_date"] != null
              ? DateFormat("dd.MM.y")
                  .format(DateTime.parse(data["father_birth_date"]))
              : null,
          father_fio: data["father_full_name"],
          father_email: data["father_email"],
          father_phoneNumber: data["father_phone_number"],
          mother_birthday: data["mother_birth_date"] != null
              ? DateFormat("dd.MM.y")
                  .format(DateTime.parse(data["mother_birth_date"]))
              : null,
          mother_fio: data["mother_full_name"],
          mother_email: data["mother_email"],
          mother_phoneNumber: data["mother_phone_number"],
          height: data["height"],
          weight: data["weight"],
          vedomstvo: data["department"],
          trainer: data["trainer_name"],
          place_of_training: data["training_place"],
          city: data["city"],
        ));
  }

  void setUserCustom(User user) {
    _user = user;
    if (user.children.isNotEmpty && user.children.length < 2) {
      _childId = user.children.first.id;
    } else if (user.children.isNotEmpty && user.children.length > 1) {
      _childId = null;
    } else {
      _childId = null;
    }
  }

  void setChildId(id) {
    _childId = id;
  }

  Future<void> setUser(data) async {
    var completer = new Completer();
    log(data.toString());
    User user = convertMapToUser(data);
    if (user.children.isNotEmpty && user.children.length < 2) {
      _childId = user.children.first.id;
    } else if (user.children.isNotEmpty && user.children.length > 1) {
      _childId = null;
    } else {
      _childId = null;
    }
    _user = user;
    completer.complete();
    return completer.future;
  }

  /// Removes all items from the cart.
  void removeAll() {
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  User get user => _user;
  get childId => _childId;
  // List<User> get list => _users;
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
  final String? documentsUrl;
  final phoneNumber;
  final gender;
  // final role = Role;
  final DateTime? birthday;
  final role;
  // final age;
  final country;
  final city;
  final firstName;
  final lastName;
  final middleName;
  final registration_date;
  final List<MinimalUser> children;
  final List parents;
  Passport passport;
  final String? photo;
  final bool admitted;
  final chatId;

  User(
      {this.id,
      this.chatId,
      this.documentsUrl,
      this.fullName,
      this.firstName,
      this.lastName,
      this.middleName,
      this.phoneNumber,
      children,
      parents,
      this.role,
      // this.role = 'guest',
      this.gender,
      this.birthday,
      // this.age,
      this.country,
      this.city,
      this.registration_date,
      required this.passport,
      this.admitted = false,
      this.photo})
      : children = children ?? [],
        parents = parents ?? [];
}

class MinimalUser {
  final String fullName;
  final id;
  final bool? marked;
  final String? role;
  final String? photo;
  final bool me;
  MinimalUser(
      {required this.fullName,
      required this.id,
      this.marked,
      this.role,
      this.me = false,
      this.photo});
}
