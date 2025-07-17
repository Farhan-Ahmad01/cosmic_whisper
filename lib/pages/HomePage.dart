import 'dart:ui';

import 'package:cosmic_whisper/bloc/chat_bloc.dart';
import 'package:cosmic_whisper/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ChatBloc chatBloc = ChatBloc();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatSuccessState:
              List<ChatMessageModel> messages =
                  (state as ChatSuccessState).messages;
              return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    // image: AssetImage('assets/space_backg.jpg'),
                    image: AssetImage('assets/galaxy_back.jpg'),
                    fit: BoxFit.fill,
                    opacity: 0.3,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 50,
                        left: 16,
                        bottom: 20,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Cosmic Whisper',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child:
                          messages.isEmpty
                              ? Center(
                                child: Lottie.asset(
                                  'assets/empty_space.json', // your Lottie file path
                                  width: 200,
                                  height: 200,
                                  repeat: true,
                                  fit: BoxFit.contain,
                                  frameRate: FrameRate.max,
                                ),
                              )
                              : ListView.builder(
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final isUser = messages[index].role == "user";
                                  return Align(
                                    alignment:
                                        isUser
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                    child: IntrinsicWidth(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          // Color(0xFF260052)
                                          bottom: 12,
                                          left: isUser ? 35 : 12,
                                          right: isUser ? 12 : 35,
                                        ),
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadiusDirectional.only(
                                                topEnd: Radius.circular(20),
                                                topStart: Radius.circular(20),
                                                bottomStart: Radius.circular(
                                                  20,
                                                ),
                                              ),
                                          gradient:
                                              isUser
                                                  ? LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      const Color(
                                                        0xFF260052,
                                                      ).withOpacity(0.2),
                                                      const Color.fromARGB(
                                                        255,
                                                        129,
                                                        31,
                                                        240,
                                                      ).withOpacity(0.1),
                                                    ],
                                                  )
                                                  : null, // no background for non-user
                                          color:
                                              isUser
                                                  ? null
                                                  : Colors.transparent,
                                        ),
                                        child: Text(
                                          messages[index].parts.first.text,
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),

                    if (chatBloc.generating)
                      Container(
                        height: 85,
                        width: 85,
                        child: Lottie.asset('assets/loading_boy.json'),
                      ),

                    SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          // Input Field
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 15,
                                  sigmaY: 15,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.1),
                                      width: 2,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: textEditingController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Whisper...',
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 15,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Color(0xFF260052)
                          const SizedBox(width: 12),
                          // Send Button
                          Material(
                            color: const Color(0xFF260052),
                            shape: const CircleBorder(),
                            elevation: 5,
                            shadowColor: Colors.white.withOpacity(0.1),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () {
                                if (textEditingController.text.isNotEmpty) {
                                  String text = textEditingController.text;
                                  textEditingController.clear();
                                  chatBloc.add(
                                    ChatGenerateNewTextMessageEvent(
                                      inputMessage: text,
                                    ),
                                  );
                                }
                              },
                              child: Transform.rotate(
                                angle: -0.85, // in radians (~ -20 degrees)
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );

            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}
