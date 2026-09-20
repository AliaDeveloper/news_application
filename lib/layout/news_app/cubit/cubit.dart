import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_application/layout/news_app/cubit/states.dart';
import 'package:news_application/modules/business/business_screen.dart';
import 'package:news_application/modules/science/science_screen.dart';
import 'package:news_application/modules/sports/sports_screen.dart';
import 'package:news_application/shared/network/local/cache_helper.dart';

import '../../../shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialStates());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sports),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.science),
      label: 'Science',
    ),
  ];

  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

  // ================= BUSINESS =================

  List<dynamic> busniess = [];

  void getBusiness() {
    emit(NewsGetBusinessLoadingStates());

    DioHelper.getData(
      url: 'v1/news/all',
      query: {
        'api_token': '7KqG15Es55KGw8g6aLbhnzx3IDXeHWAYD6b00r2j',
        'language': 'en',
        'categories': 'business',
        'limit': 3,
      },
    ).then((value) {
      print('BUSINESS DATA: ${value.data}');

      busniess = value.data['data'];

      if (busniess.isNotEmpty) {
        print(busniess[0]['title']);
      }

      emit(NewsGetBusinessSuccessStates());
    }).catchError((error) {
      print('BUSINESS ERROR: ${error.toString()}');

      emit(
        NewsGetBusinessErrorStates(
          error.toString(),
        ),
      );
    });
  }

  // ================= SPORTS =================

  List<dynamic> sports = [];

  void getSports() {
    if (sports.isEmpty) {
      emit(NewsGetSportsLoadingStates());

      DioHelper.getData(
        url: 'v1/news/all',
        query: {
          'api_token': '7KqG15Es55KGw8g6aLbhnzx3IDXeHWAYD6b00r2j',
          'language': 'en',
          'categories': 'sports',
          'limit': 3,
        },
      ).then((value) {
        print('SPORTS DATA: ${value.data}');

        sports = value.data['data'];

        if (sports.isNotEmpty) {
          print(sports[0]['title']);
        }

        emit(NewsGetSportsSuccessStates());
      }).catchError((error) {
        print('SPORTS ERROR: ${error.toString()}');

        emit(
          NewsGetSportsErrorStates(
            error.toString(),
          ),
        );
      });
    } else {
      emit(NewsGetSportsSuccessStates());
    }
  }

  // ================= SCIENCE =================

  List<dynamic> science = [];

  void getScience() {
    emit(NewsGetScienceLoadingStates());

    if (science.isEmpty) {
      DioHelper.getData(
        url: 'v1/news/all',
        query: {
          'api_token': '7KqG15Es55KGw8g6aLbhnzx3IDXeHWAYD6b00r2j',
          'language': 'en',
          'categories': 'science',
          'limit': 3,
        },
      ).then((value) {
        print('SCIENCE DATA: ${value.data}');

        science = value.data['data'];

        if (science.isNotEmpty) {
          print(science[0]['title']);
        }

        emit(NewsGetScienceSuccessStates());
      }).catchError((error) {
        print('SCIENCE ERROR: ${error.toString()}');

        emit(
          NewsGetScienceErrorStates(
            error.toString(),
          ),
        );
      });
    } else {
      emit(NewsGetScienceSuccessStates());
    }
  }

  // ================= BOTTOM NAVIGATION =================

  void changeBottomNavBar(int index) {
    currentIndex = index;

    if (index == 0) {
      if (busniess.isEmpty) {
        getBusiness();
      } else {
        emit(NewsBottomNavStates());
      }
    }

    if (index == 1) {
      getSports();
    }

    if (index == 2) {
      getScience();
    }

    emit(NewsBottomNavStates());
  }

  // ================= DARK MODE =================

  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(NewsChangeModeStates());
    } else {
      isDark = !isDark;

      CacheHelper.putBoolean(
        key: 'isDark',
        value: isDark,
      ).then((value) {
        emit(NewsChangeModeStates());
      });
    }
  }

  List<dynamic> search = [];
  void getSearch(String value) {
    emit(NewsGetSearchLoadingStates());
//    search = [];
    DioHelper.getData(
      url: 'v1/news/all',
      query: {
        'api_token': '7KqG15Es55KGw8g6aLbhnzx3IDXeHWAYD6b00r2j',
        'language': 'en',
        'search': '$value',
      },
    ).then((value) {
      print('SEARCH DATA: ${value.data}');
      search = value.data['data'];
      if (search.isNotEmpty) {
        print(search[0]['title']);
      }
      emit(NewsGetSearchSuccessStates());
    }).catchError((error) {
      print('SEARCH ERROR: ${error.toString()}');
      emit(
        NewsGetSearchErrorStates(
          error.toString(),
        ),
      );
    });

  }
}






