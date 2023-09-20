import 'package:meet_me/pages/screens.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: primaryColor,
        image: DecorationImage(
          image: AssetImage('assets/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: whiteColor,
            ),
          ),
        ),
        body: addYourPhoto(context),
      ),
    );
  }

  addYourPhoto(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding * 2.0,
            vertical: fixPadding * 3.5,
          ),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Your Photo',
                    style: black14SemiBoldTextStyle,
                  ),
                  InkWell(
                    onTap: () {
                      currentIndex = 0;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomBar()),
                      );
                    },
                    child: Text(
                      'Add it later',
                      style: grey14RegularTextStyle,
                    ),
                  ),
                ],
              ),
              heightSpace,
              heightSpace,
              heightSpace,
              heightSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      currentIndex = 0;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomBar()),
                      );
                    },
                    child: Container(
                      height: 70,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 2.0),
                            color: greyColor.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/icons/profile.png',
                        color: greyColor,
                        height: 35,
                        width: 35,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      currentIndex = 0;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomBar()),
                      );
                    },
                    child: Container(
                      height: 70,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xfff1f8e9),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 2.0),
                            color: greyColor.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.photo_library_rounded,
                            color: blackColor,
                            size: 30,
                          ),
                          Text(
                            'Gallery',
                            style: black11SemiBoldTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      currentIndex = 0;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomBar()),
                      );
                    },
                    child: Container(
                      height: 70,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xffe0f2f1),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 2.0),
                            color: greyColor.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.photo_camera,
                            color: blackColor,
                            size: 30,
                          ),
                          Text(
                            'Take Photo',
                            style: black11SemiBoldTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
