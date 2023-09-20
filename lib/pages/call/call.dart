import 'package:meet_me/pages/screens.dart';

class Call extends StatelessWidget {
  const Call({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/users/user11.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileImage(),
            heightSpace,
            heightSpace,
            heightSpace,
            heightSpace,
            heightSpace,
            heightSpace,
            options(context),
            heightSpace,
            heightSpace,
            heightSpace,
            heightSpace,
            textField(),
          ],
        ),
      ),
    );
  }

  profileImage() {
    return Container(
      height: 100,
      width: 105,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: const DecorationImage(
          image: AssetImage('assets/users/user1.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  options(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xffe6e6e6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mic_off_rounded,
              color: blackColor,
              size: 22,
            ),
          ),
        ),
        widthSpace,
        widthSpace,
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.call_end,
              color: whiteColor,
              size: 22,
            ),
          ),
        ),
        widthSpace,
        widthSpace,
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.videocam_rounded,
              color: whiteColor,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  textField() {
    return Container(
      height: 45,
      padding: const EdgeInsets.all(fixPadding),
      color: whiteColor,
      alignment: Alignment.center,
      child: TextField(
        cursorColor: primaryColor,
        style: black14SemiBoldTextStyle,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.only(top: 2),
          hintText: 'Type your message',
          hintStyle: grey12RegularTextStyle,
          prefixIcon: const Icon(
            Icons.emoji_emotions_outlined,
            color: greyColor,
            size: 15,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.attach_file,
                size: 13,
                color: greyColor,
              ),
              widthSpace,
              widthSpace,
              const Icon(
                Icons.photo_camera,
                size: 13,
                color: greyColor,
              ),
              widthSpace,
              widthSpace,
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: whiteColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: greyColor.withOpacity(0.15),
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mic,
                  size: 11,
                  color: greyColor,
                ),
              ),
              widthSpace,
              widthSpace,
              widthSpace,
              widthSpace,
            ],
          ),
          border: const UnderlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
