import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meet_me/pages/screens.dart';

class MatchResult extends StatelessWidget {
  final String? image;
  MatchResult({Key? key, this.image}) : super(key: key);

  final hobbyList = [
    {
      'hobby': 'Cooking',
      'match': true,
    },
    {
      'hobby': 'Movies',
      'match': false,
    },
    {
      'hobby': 'Pets',
      'match': false,
    },
    {
      'hobby': 'Painting',
      'match': true,
    },
    {
      'hobby': 'Music',
      'match': true,
    },
    {
      'hobby': 'Gardening',
      'match': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        titleSpacing: 0,
        title: Text(
          'Matching Results',
          style: black20BoldTextStyle,
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          matchingProfile(context),
          matchingResult(context),
        ],
      ),
    );
  }

  getImageWidget() {
    return image!=null ? NetworkImage(image!) : AssetImage('assets/logo.jpg');
  }

  matchingProfile(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        fixPadding * 2.0,
        fixPadding * 2.0,
        fixPadding * 2.0,
        fixPadding * 2.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: getImageWidget(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              heightSpace,
              heightSpace,
              Text(
                'Azhar Khan',
                style: black14SemiBoldTextStyle,
              ),
              Text(
                '#159874',
                style: grey13RegularTextStyle,
              ),
              Text(
                '26 Male, Delhi',
                style: grey13RegularTextStyle,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(fixPadding * 2.6),
            child: Text(
              '95%',
              style: primaryColor16BlackTextStyle,
            ),
          ),
          InkWell(
            onTap: () {
              // if (totalVisitCount == "Unlimited" || myVisitCount < int.parse(totalVisitCount)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileDetails(
                      tag: 'profile',
                      image: image,
                      id: '#121345',
                    ),
                  ),
                );
              // }
              // else {
              //   showSnackBar(context,
              //       'Your daily profile visit limit has exceeded');
              // }


            },
            child: Column(
              children: [
                Hero(
                  tag: 'profile',
                  child: Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: AssetImage(image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                heightSpace,
                heightSpace,
                Text(
                  'Rashmika John',
                  style: black14SemiBoldTextStyle,
                ),
                Text(
                  '#121345',
                  style: grey13RegularTextStyle,
                ),
                Text(
                  '24 Female, Delhi',
                  style: grey13RegularTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  matchingResult(context) {
    return Column(
      children: [
        basicDetails(),
        interestAndHobbies(),
        religionAndWork(),
        education(),
        chatAndCallButton(context),
      ],
    );
  }

  basicDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: fixPadding * 2.0,
        vertical: fixPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
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
            child: Text(
              '01',
              style: black13BoldTextStyle,
            ),
          ),
          widthSpace,
          widthSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Basic Details',
                      style: black15BoldTextStyle,
                    ),
                    Text(
                      '100%',
                      style: primaryColor13BlackTextStyle,
                    ),
                  ],
                ),
                heightSpace,
                heightSpace,
                Text(
                  'Living In - Delhi, India',
                  style: grey13SemiBoldTextStyle,
                ),
                const SizedBox(height: 3),
                Text(
                  'Status - Never Married',
                  style: grey13SemiBoldTextStyle,
                ),
                const SizedBox(height: 3),
                Text(
                  'Income - 32000',
                  style: grey13SemiBoldTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  interestAndHobbies() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        fixPadding * 2.0,
        0,
        fixPadding * 2.0,
        fixPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
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
            child: Text(
              '02',
              style: black13BoldTextStyle,
            ),
          ),
          widthSpace,
          widthSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Interest and Hobbies',
                      style: black15BoldTextStyle,
                    ),
                    Text(
                      '95%',
                      style: primaryColor13BlackTextStyle,
                    ),
                  ],
                ),
                heightSpace,
                heightSpace,
                StaggeredGrid.count(
                  // staggeredTileBuilder: (_) => const StaggeredTile.fit(2),
                  // shrinkWrap: true,
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: hobbyChilds(),
                  // itemCount: hobbyList.length,
                  // itemBuilder: (context, index) {
                  //   final item = hobbyList[index];
                  //   return Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: fixPadding,
                  //       vertical: 3,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       border: Border.all(color: greyColor),
                  //       borderRadius: BorderRadius.circular(3),
                  //     ),
                  //     child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Text(
                  //           item['hobby'] as String,
                  //           style: grey13SemiBoldTextStyle,
                  //         ),
                  //         widthSpace,
                  //         Icon(
                  //           item['match']! == true ? Icons.done : Icons.close,
                  //           color: item['match']! == true
                  //               ? Colors.green
                  //               : Colors.red,
                  //           size: 16,
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> hobbyChilds(){
    List<Widget> childrens = <Widget>[];
    for(int i = 0; i < hobbyList.length; i++)
      {
        final item = hobbyList[i];
        Widget child  = Container(
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                item['hobby'] as String,
                style: grey13SemiBoldTextStyle,
              ),
              widthSpace,
              Icon(
                item['match']! == true ? Icons.done : Icons.close,
                color: item['match']! == true
                    ? Colors.green
                    : Colors.red,
                size: 16,
              ),
            ],
          ),
        );
        childrens.add(child);
      }
    return childrens;
  }

  religionAndWork() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        fixPadding * 2.0,
        0,
        fixPadding * 2.0,
        fixPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
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
            child: Text(
              '03',
              style: black13BoldTextStyle,
            ),
          ),
          widthSpace,
          widthSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Religion and Work',
                      style: black15BoldTextStyle,
                    ),
                    Text(
                      '100%',
                      style: primaryColor13BlackTextStyle,
                    ),
                  ],
                ),
                heightSpace,
                heightSpace,
                Text(
                  'Religion - Gujarati',
                  style: grey13SemiBoldTextStyle,
                ),
                const SizedBox(height: 3),
                Text(
                  'Work - Software Developer',
                  style: grey13SemiBoldTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  education() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        fixPadding * 2.0,
        0,
        fixPadding * 2.0,
        fixPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
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
            child: Text(
              '04',
              style: black13BoldTextStyle,
            ),
          ),
          widthSpace,
          widthSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Education',
                      style: black15BoldTextStyle,
                    ),
                    Text(
                      '100%',
                      style: primaryColor13BlackTextStyle,
                    ),
                  ],
                ),
                heightSpace,
                heightSpace,
                Text(
                  'BCA / MCA',
                  style: grey13SemiBoldTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  chatAndCallButton(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Chat("","","")),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Image.asset(
              'assets/icons/chat.png',
              color: whiteColor,
              height: 16,
              width: 16,
            ),
          ),
        ),
        widthSpace,
        widthSpace,
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Call()),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(
              Icons.call_outlined,
              color: whiteColor,
              size: 16,
            ),
          ),
        ),
        widthSpace,
        widthSpace,
        widthSpace,
        widthSpace,
      ],
    );
  }
}
