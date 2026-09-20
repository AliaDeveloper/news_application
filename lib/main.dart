import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:news_application/shared/bloc_observer.dart';
import 'package:news_application/shared/network/local/cache_helper.dart';
import 'package:news_application/shared/network/remote/dio_helper.dart';

import 'layout/news_app/cubit/cubit.dart';
import 'layout/news_app/cubit/states.dart';
import 'layout/news_app/news_layout.dart';

void main() async {
  // بيتاكد ان كل حاجة هنا في الميثود خلصت و بعدين يفتح التطبيق
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  DioHelper.init();

  await CacheHelper.init();

  bool? isDark = CacheHelper.getBoolean(key: 'isDark');

  runApp(MyApp(isDark));
}


class MyApp extends StatelessWidget {
  final bool? isDark;

  const MyApp(this.isDark, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:(context) => NewsCubit()..getBusiness()..getSports()..getScience(),),
        BlocProvider(create: (context) => NewsCubit()..changeAppMode(
    fromShared: isDark,
    ), ),
      ],
      child: BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.purple,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                titleSpacing: 20.0,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,

              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.purple,
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.purple,
                unselectedItemColor: Colors.grey,
                backgroundColor: Colors.white,
                elevation: 20.0,
              ),
              textTheme: TextTheme(
                  bodyMedium: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Colors.black,
                  )
              ),
            ),
            darkTheme: ThemeData(
              // scaffoldBackgroundColor: HexColor('333739'),
              primarySwatch: Colors.purple,
              appBarTheme: AppBarTheme(
                titleSpacing: 20.0,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Color(0xFF333739),
                  statusBarIconBrightness: Brightness.light,
                ),
                backgroundColor: Color(0xFF333739),
                elevation: 0.0,

              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Color(0xFF333739),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.purple,
                backgroundColor: Colors.white,
                unselectedItemColor: Colors.grey,

                elevation: 20.0,
              ),
              textTheme: TextTheme(
                  bodyMedium: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Colors.white,
                  )
              ),
              scaffoldBackgroundColor: const Color(0xFF333739),
            ),
            themeMode: NewsCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: NewsLayout(),
          );
        },
      ),
    );
  }
}

