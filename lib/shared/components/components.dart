import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:news_application/models/web_view/web_view_screen.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
  VoidCallback? onTap,
  FormFieldValidator<String>? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  VoidCallback? suffixPressed,
  bool isPassword = false,
  bool isClickable = true,

}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null ? IconButton(
          onPressed: suffixPressed,
            icon: Icon(suffix)) : null,
        border: OutlineInputBorder(),
      ),
    );



Widget myDivider() =>  Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);

Widget buildArticleItem(article, context) => InkWell(
  onTap: (){
    navigateTo(context, WebViewScreen(article['url']));
  },
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Container(
          width: 120.0,
          height: 120.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: NetworkImage(
                article['image_url'] ?? '',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),

        SizedBox(
          width: 20.0,
        ),

        Expanded(
          child: Container(
            height: 120.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    article['title'] ?? 'No Title',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                Text(
                  article['published_at'] ?? '',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
);


Widget articleBuilder(list, {isSearch = false}) => ConditionalBuilder(
  condition: list.isNotEmpty,

  builder: (context) => ListView.separated(
    physics: BouncingScrollPhysics(),

    itemBuilder: (context, index) {
      return buildArticleItem(
        list[index],
        context,
      );
    },

    separatorBuilder: (context, index) => myDivider(),

    itemCount: list.length,
  ),

  fallback: (context) => isSearch ? Container() : Center(
    child: CircularProgressIndicator(),
  ),
);

void navigateTo(context,widget) => Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => widget,
    ),
);


