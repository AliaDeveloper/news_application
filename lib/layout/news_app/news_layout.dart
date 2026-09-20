import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:news_application/modules/search/search_screen.dart';
import 'package:news_application/shared/components/components.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';


class NewsLayout extends StatelessWidget {
  const NewsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = NewsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('NEWS APP'),
            actions: [
              IconButton(
                  onPressed: (){
                    navigateTo(context, SearchScreen());
                  },
                  icon: Icon(Icons.search)
              ),
              IconButton(
                  onPressed: (){
                    NewsCubit.get(context).changeAppMode();
                  },
                  icon: Icon(Icons.brightness_4_outlined)
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
              onTap: (index)
            {
              cubit.changeBottomNavBar(index);
            },
              items: cubit.bottomItems,
          ),
        );
      },
    );
  }
}








