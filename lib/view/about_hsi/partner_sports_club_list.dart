import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/sub_sectiono_about_hsi_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/sub_screen_hsi_sections_helper.dart';
import '../../custom/custom_appbar_subscreen.dart';
import '../partner_club/partner_club_detail.dart';

// load Partner Sports Club List details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class AoildarfelogHsi extends StatefulWidget {
  final int id;
  final String name;
  final String image;
  const AoildarfelogHsi({
    super.key,
    required this.id,
    required this.name,
    required this.image,
  });

  @override
  State<AoildarfelogHsi> createState() => _AoildarfelogHsi();
}

class _AoildarfelogHsi extends State<AoildarfelogHsi> {
  List<GeneralInfo> generalInfo = [];
  List<Club> clubs = [];
  List<NationalTeam> nationalTeams = [];
  bool isLoading = true;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Load data from the SubScreenHaiSectionsHelper class via the web service
  Future<void> fetchData() async {
    try {
      final response = await fetchGeneralInfo(widget.id);
      setState(() {
        generalInfo = response.generalInfo;
        clubs = response.clubs;
        nationalTeams = response.nationalTeams;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        showNetworkErrorDialog(context);
      }
      print("Error fetching data: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBarSubScreen(
                title: widget.name,
                imagePath: widget.image,
              ),
              Expanded(child: _leagueList(screenHeight, screenWidth)),
            ],
          ),
          if (isLoading)
            Positioned.fill(child: Center(child: loadingAnimation)),
        ],
      ),
    );
  }

  // Custom widget for displaying partners list data using a GridView.
  Widget _leagueList(double screenHeight, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: GridView.builder(
        itemCount: clubs.length,
        itemBuilder: (context, index) {
          final club = clubs[index];
          return _leagueTile(club, screenHeight, screenWidth, index);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: screenWidth > 600 ? 3 : 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }

  // Custom widget for displaying the GridView UI.
  Widget _leagueTile(
    Club club,
    double screenHeight,
    double screenWidth,
    int index,
  ) {
    bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => PartnerClubDetail(
                  clubId: club.id,
                  title: club.name,
                  image: club.image,
                ),
          ),
        );

        print("${club.name} Button clicked");
        setState(() {
          selectedIndex = isSelected ? null : index;
        });
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSelected ? selectedCart : unselectedCart,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Center(
                  child: Container(
                    height: 55.h,
                    width: 55.w,
                    child: Image.network(club.image, fit: BoxFit.contain),
                  ),
                ),
                SizedBox(height: screenHeight * 0.020),
                Text(
                  club.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
              ],
            ),
          ),
          //
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              alignment: Alignment.topRight,
              child: Image.asset(
                share,
                width: 24.w,
                height: 24.h,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
