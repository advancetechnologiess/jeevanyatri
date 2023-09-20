import 'package:meet_me/pages/screens.dart';

class ProfileViews extends StatefulWidget {
  const ProfileViews({Key? key}) : super(key: key);

  @override
  _ProfileViewsState createState() => _ProfileViewsState();
}

class _ProfileViewsState extends State<ProfileViews> {
  final profileList = [
    {
      'image': 'assets/users/user3.png',
      'name': 'Samantha John',
      'occupation': 'Software Developer',
      'year': '26',
      'height': '5 ft 2 in',
      'religion': 'Khatri - Hindu',
      'city': 'Delhi',
      'country': 'India',
      'star': false,
    },
    {
      'image': 'assets/users/user4.png',
      'name': 'Rashmika John',
      'occupation': 'UI / Ux Designer',
      'year': '25',
      'height': '5 ft 1 in',
      'religion': 'Khatri - Hindu',
      'city': 'Delhi',
      'country': 'India',
      'star': false,
    },
    {
      'image': 'assets/users/user5.png',
      'name': 'Tina Patel',
      'occupation': 'React Developer',
      'year': '22',
      'height': '5 ft 5 in',
      'religion': 'Khatri - Hindu',
      'city': 'Delhi',
      'country': 'India',
      'star': true,
    },
    {
      'image': 'assets/users/user6.png',
      'name': 'Zoya Doe',
      'occupation': 'Software Developer',
      'year': '28',
      'height': '5 ft 5 in',
      'religion': 'Khatri - Hindu',
      'city': 'Delhi',
      'country': 'India',
      'star': false,
    },
    {
      'image': 'assets/users/user7.png',
      'name': 'Isha Patel',
      'occupation': 'Software Developer',
      'year': '29',
      'height': '5 ft 5 in',
      'religion': 'Khatri - Hindu',
      'city': 'Delhi',
      'country': 'India',
      'star': true,
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
          'Profile Views',
          style: black20BoldTextStyle,
        ),
      ),
      body: profileViewsList(),
    );
  }

  profileViewsList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: profileList.length,
      itemBuilder: (context, index) {
        final item = profileList[index];
        return Padding(
          padding: EdgeInsets.fromLTRB(
            fixPadding * 2.0,
            index == 0 ? fixPadding * 2.0 : 0,
            fixPadding * 2.0,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileDetails(
                      tag: profileList[index],
                      image: item['image'] as String?,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: AssetImage(item['image'] as String),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    widthSpace,
                    widthSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'] as String,
                            style: black14SemiBoldTextStyle,
                          ),
                          Text(
                            '${item['occupation']}   ${item['year']} yrs, ${item['height']}',
                            style: grey12RegularTextStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item['religion']}, ${item['city']} - ${item['country']}',
                                style: grey12RegularTextStyle,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    item['star'] = !(item['star'] as bool);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: item['star']! == true
                                          ? const Text('Add to shortlist')
                                          : const Text('Remove from shortlist'),
                                    ),
                                  );
                                },
                                child: Icon(
                                  item['star']! == true
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              divider(),
            ],
          ),
        );
      },
    );
  }

  divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: fixPadding * 2.0),
      color: greyColor,
      height: 1,
      width: double.infinity,
    );
  }
}
