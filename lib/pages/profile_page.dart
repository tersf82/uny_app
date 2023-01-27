import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../blocs/app_blocs.dart';
import '../blocs/app_events.dart';
import '../blocs/app_states.dart';
import '../models/models.dart';
import '../repos/repositories.dart';
import '../slider/slider_color.dart';

class ProfilPage extends StatefulWidget {
  ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final _scaffoldKeyforBottomSheet =
      GlobalKey<ScaffoldState>(); // for bottom sheet
  final myController = TextEditingController(); // for comment text
  final List<Characteristic> mockCharacteristics = [
    Characteristic(id: 1, title: 'Компетентный сотрудник', emoji: '\u{1F4BC}'),
    Characteristic(id: 2, title: 'Лучший друг', emoji: '\u{1F61C}'),
    Characteristic(id: 3, title: 'Открытый', emoji: '\u{1F60A}'),
    Characteristic(id: 4, title: 'Зоошиза', emoji: '\u{1F408}'),
    Characteristic(id: 5, title: 'Ест пиццу с ананасами', emoji: '\u{1F922}'),
    Characteristic(id: 6, title: 'Неадекватный веган', emoji: '\u{1F621}'),
    Characteristic(id: 7, title: 'Красиво поёт', emoji: '\u{1F3A4}'),
    Characteristic(id: 8, title: 'Круто одевается', emoji: '\u{1F413}'),
    Characteristic(id: 9, title: 'Много спит', emoji: '\u{1F634}'),
    Characteristic(id: 10, title: 'Сплетничает', emoji: '\u{1F3A4}'),
  ];
  late User mockUser;

  List<String> tagChips = []; // selected
  List<String> optionChips = []; // all chips
  double sliderValue = 5; //initial slider value
  int profileStar = 5;
  bool is5star = false; // if profileStar 5 star then green color

  @override
  void initState() {
    super.initState();
    mockUser = User(
      id: 1,
      name: 'Антон Дегтярёв',
      photoUrl: 'assets/profil_photo.png',
      rating: 8.7,
      characteristics: {
        mockCharacteristics[0]: 85,
        mockCharacteristics[1]: 29,
        mockCharacteristics[2]: 12,
        mockCharacteristics[3]: 8,
        mockCharacteristics[4]: 1,
        mockCharacteristics[5]: 2,
        mockCharacteristics[6]: 4,
      },
      reviews: [],
    );
    for (int i = 0; i < 7; i++) {
      optionChips.add(
          mockCharacteristics[i].title + ' ' + mockCharacteristics[i].emoji);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateNow = formatter.format(now);
    final double width = MediaQuery.of(context).size.width;

    return buildBlocProvider(dateNow, width);
  }

  BlocProvider<CommentBloc> buildBlocProvider(String dateNow, double width) {
    return BlocProvider(
      create: (context) => CommentBloc(
        RepositoryProvider.of<UserRepository>(context),
      )..add(CommentUserEvent()),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          key: _scaffoldKeyforBottomSheet,
          body: profile(dateNow, width)),
    );
  }

  Container profile(String dateNow, double width) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            profilePhoto(
                'Рейтинг профиля',
                Icon(Icons.arrow_back),
                Icon(
                  Icons.arrow_back,
                  color: Colors.transparent,
                )),
            Container(
              color: Colors.white,
              height: 200,
              child: chipMethod(),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: EdgeInsets.only(left: 40, bottom: 5),
                child: Align(
                  child: Text(
                    'Отзывы',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.centerLeft,
                )),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.greenAccent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  )),
              onPressed: () {
                _scaffoldKeyforBottomSheet.currentState!.showBottomSheet(
                    constraints:
                        const BoxConstraints(minWidth: double.infinity),
                    elevation: 20, (context) {
                  return bottomSheet();
                });
              },
              child: Container(
                height: 40,
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit,
                      color: Color(0xff0E9D16),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Оставить отзыв',
                      style: TextStyle(color: Color(0xff0E9D15)),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                height: 300,
                child: BlocBuilder<CommentBloc, CommentState>(
                  builder: (context, state) {
                    if (state is UserLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    int i = 0;
                    if (state is CommentLoadedState) {
                      List<CommentModel> commentList = state.comments;
                      while (i < 20) {
                        i++;
                        mockUser.reviews.add(commentList[i]);
                      }

                      //     print(mockUser.reviews.length);

                      return ListView.builder(
                        itemCount: mockUser.reviews.length,
                        //commentList.length,
                        itemBuilder: (context, index) {
                          if (index == 1 || index == 11) {
                            is5star = true;
                          } else {
                            is5star = false;
                          }

                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, top: 5),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        is5star
                                            ? Color(0xff0D9C13).withOpacity(.9)
                                            : Colors.grey,
                                        is5star
                                            ? Color(0xff11B97C).withOpacity(.9)
                                            : Colors.grey,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 196, 193, 193),
                                        width: 0.5)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                                color: is5star
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14),
                                            children: [
                                              TextSpan(
                                                text: commentList[index]
                                                    .email!
                                                    .substring(
                                                        0,
                                                        commentList[index]
                                                            .email!
                                                            .indexOf('@')),
                                                style: TextStyle(
                                                    color: is5star
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 14),
                                              ),
                                              TextSpan(
                                                text: is5star
                                                    ? " $profileStar  "
                                                    : '',
                                              ),
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.star,
                                                  size: 14,
                                                  color: is5star
                                                      ? Colors.white
                                                      : Colors.transparent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          dateNow,
                                          style: TextStyle(
                                              color: is5star
                                                  ? Colors.grey.shade200
                                                  : Colors.black),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      commentList[index].body!,
                                      style: TextStyle(
                                          color: is5star
                                              ? Colors.grey.shade200
                                              : Colors.black),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: is5star,
                                child: Positioned(
                                    right: (width - 40),
                                    child: SvgPicture.asset(
                                      'assets/left_svg.svg',
                                      height: 50,
                                      width: 50,
                                    )),
                              ),
                              Visibility(
                                visible: is5star, //isFiveStar ,
                                child: Positioned(
                                    left: width - 40,
                                    child: SvgPicture.asset(
                                      'assets/right_svg.svg',
                                      height: 50,
                                      width: 50,
                                    )),
                              )
                            ],
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ))
          ],
        ),
      ),
    );
  }

  StatefulBuilder bottomSheet() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 10 * 9,
          child: SizedBox(
              width: 200,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    profilePhoto(
                        'Оставить отзыв',
                        Text(
                          '     Отмена',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        Text(
                          '     Отмена',
                          style: TextStyle(color: Colors.transparent),
                        )),
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            sliderValue.toInt().toString(),
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          Text('/10',style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                    ),
                    SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                            trackShape: GradientRectSliderTrackShape()),
                        child: Slider(
                          activeColor: Colors.greenAccent,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: sliderValue.round().toString(),
                          value: sliderValue,
                          onChanged: (double val) {
                            setState(() {
                              sliderValue = val;
                            });
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: TextField(
                        controller: myController,
                        maxLines: 3,
                        decoration: new InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3, color: Colors.grey.shade200)),
                            hintText: 'Напишите отзыв'),
                      ),
                    ),
                    ChipsChoice<String>.multiple(
                      value: tagChips,
                      onChanged: (val) => setState(() {
                        tagChips = val;
                        //  print(val);
                      }),
                      choiceItems: C2Choice.listFrom(
                          source: optionChips,
                          value: (i, v) {
                            print(i);
                            return v;
                          },
                          label: (i, v) {
                            return v;
                          },
                          disabled: (i, v) => [0, 2, 5].contains('a')),

                      choiceActiveStyle: C2ChoiceStyle(
                          color: Colors.red,
                          borderColor: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      choiceStyle: C2ChoiceStyle(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      wrapped: true,

                      // choiceStyle: choiceStyle
                    ),
                    InkWell(
                      onTap: () {
                       Navigator.pop(context);


                      },
                      child: Container(
                        height: 40,
                        width: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xff910AFB)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Опубликовать',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text('Нажимая "Опубликовать", вы подтверждаете'),
                        Text('согласие с условиями использования Uny',
                            style: TextStyle(color: Colors.blue))
                      ],
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget profilePhoto(
      String profileText, Widget widgetVisible, Widget widgetInvisible) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: widgetVisible,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Text(
              profileText,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: widgetInvisible,
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(mockUser.photoUrl),
                ),
                RotatedBox(
                  quarterTurns: 2,
                  child: CircularPercentIndicator(
                      radius: 80,
                      lineWidth: 15.0,
                      percent: sliderValue / 10,
                      center: new Text("75%",
                          style: TextStyle(color: Color(0xFF535355))),
                      linearGradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: <Color>[Colors.red, Colors.lightGreenAccent]),
                      rotateLinearGradient: true,
                      circularStrokeCap: CircularStrokeCap.round),
                ),
              ],
            ),
            Container(
              height: 30,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(
                  colors: [
                    Color(0xff0D9C13).withOpacity(.9),
                    Color(0xff27F710).withOpacity(.9),
                  ],
                ),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    children: [
                      TextSpan(
                          text:
                              ((mockUser.rating + sliderValue) / 2).toString()),
                      WidgetSpan(
                        child: Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        Text(
          mockUser.name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget chipMethod() {
    return ChipsChoice<String>.multiple(
      clipBehavior: Clip.none,

      value: tagChips,
      onChanged: (val) => setState(() {
       // tagChips = val;
      }),
      choiceItems: C2Choice.listFrom(
        source: optionChips,
        value: (i, v) {
          return v;
        },
        label: (i, v) {
          return v;
        },
      ),
      choiceActiveStyle: C2ChoiceStyle(
          color: Colors.red,
          borderColor: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      choiceStyle: C2ChoiceStyle(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      wrapped: true,

      // choiceStyle: choiceStyle
    );
  }
}
