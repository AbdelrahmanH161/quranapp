
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quranapp/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quranapp/models/QuranApiService.dart';

class DetailScreen extends StatefulWidget {
  final String nameOfSurah;
  final String TranslatedNsme;
  final String numberOfAyahs;
  final String revelationType;
  final String surahNumber;
  const DetailScreen(
      {super.key,
        required this.nameOfSurah,
        required this.TranslatedNsme,
        required this.numberOfAyahs,
        required this.revelationType,
        required this.surahNumber});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<dynamic> surahArinfo = [];
  List<dynamic> surahEninfo = [];

  @override
  void initState() {

    super.initState();
    QuranApiService.fetchQuranArabicInfo(widget.surahNumber).then((arabicInfo) {
      setState(() {
        surahArinfo = arabicInfo;
      });
    });

    QuranApiService.fetchQuranEnglishInfo(widget.surahNumber).then((englishInfo) {
      setState(() {
        surahEninfo = englishInfo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        appBar: _AppBar(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: _Details(),
            )
          ],
          body: surahArinfo.isEmpty || surahEninfo.isEmpty
              ? const Center(
              child:
              CircularProgressIndicator()) // Show loading indicator while data is being fetched
              : ListView.builder(
            itemCount: surahArinfo.length,
            itemBuilder: (context, index) {
              final arabicAyah = surahArinfo[index]['text'].toString();
              final englishAyah = surahEninfo[index]['text'].toString();
              final ayahNumber = index + 1;
              return _ayatItem(
                arabicAyah: arabicAyah,
                englishAyah: englishAyah,
                ayahNumber: ayahNumber,
              );
            },
          ),
        ));
  }


  Widget _ayatItem(
      {required String arabicAyah,
        required String englishAyah,
        required int ayahNumber}) =>
      Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: gray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(27 / 2),
                    ),
                    child: Center(
                      child: Text(
                        '$ayahNumber',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.share_outlined,
                    color:  Color(0xFF9055FF),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(
                    Icons.play_arrow_outlined,
                    color:  Color(0xFF9055FF),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(
                    Icons.bookmark_outline,
                    color:  Color(0xFF9055FF),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              arabicAyah,
              style: GoogleFonts.amiri(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              englishAyah,
              style: GoogleFonts.poppins(
                color: text,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );

  Widget _Details() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Stack(children: [
      Container(
        height: 257,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0,
                  .6,
                  1
                ],
                colors: [
                  Color(0xFFDF98FA),
                  Color(0xFFB070FD),
                  Color(0xFF9055FF)
                ])),
      ),
      Positioned(
          bottom: 0,
          right: 0,
          child: Opacity(
              opacity: .2,
              child: SvgPicture.asset(
                'assets/svgs/quran.svg',
                width: 324 - 55,
              ))),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Text(
              widget.nameOfSurah,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 26),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              widget.TranslatedNsme,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
            Divider(
              color: Colors.white.withOpacity(.35),
              thickness: 2,
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.revelationType.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.white),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '${widget.numberOfAyahs} VERSES',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            SvgPicture.asset('assets/svgs/bismillah.svg')
          ],
        ),
      )
    ]),
  );

  AppBar _AppBar() {
    return AppBar(
      backgroundColor: background,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: SvgPicture.asset('assets/svgs/back-icon.svg')),
          const SizedBox(
            width: 24,
          ),
          Text(
            widget.nameOfSurah,
            style: GoogleFonts.inter(
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/svgs/search-icon.svg')),
        ],
      ),
    );
  }
}