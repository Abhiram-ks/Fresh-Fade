
import 'package:client_pannel/core/images/app_images.dart';
import 'package:client_pannel/features/app/domain/entity/barber_entity.dart';
import 'package:client_pannel/features/app/presentations/widget/search_widget/barber_custom_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../state/bloc/fetch_bloc/fetch_barber_bloc/fetch_barber_bloc_bloc.dart';
import 'barber_loading_screen.dart';

class BarberListBuilder extends StatefulWidget {
  const BarberListBuilder({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  State<BarberListBuilder> createState() => _BarberListBuilderState();
}

class _BarberListBuilderState extends State<BarberListBuilder> with  AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<FetchAllbarberBloc, FetchAllbarberListState>(
      buildWhen: (previous, current) {
        return true;
      },
      builder: (context, state) {
         if (state is FetchAllbarberListEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    ConstantWidgets.hight50(context),
                    Image.asset(AppImages.appLogo,height: 50,width: 50,),
                    Text('No matching shops found.', style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                    Text('Try adjusting your search or filters.', style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
                ],
              ),
            ),
          );
        }
         else if (state is FetchAllbarberSuccess) {
          final List<BarberEntity> barbers = state.barbers;
    
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final barber = barbers[index];
                return Column(
                  children: [
                       ListForBarbers(
                        ontap: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pushNamed(context, AppRoutes.detailBarber, arguments: barber.uid);
                        },
                        screenHeight: widget.screenHeight,
                        screenWidth: widget.screenWidth,
                        imageURl: barber.image ?? AppImages.barberEmpty,
                        rating: barber.rating,
                        shopName: barber.ventureName,
                        shopAddress: barber.address,
                        isBlocked: barber.isBloc,
                      ),
                    if (index < barbers.length - 1)
                      ConstantWidgets.hight10(context),
                  ],
                );
              },
              childCount: barbers.length,
            ),
          );
        }
        else if (state is FetchAllbarberFailure){
               return SliverToBoxAdapter(
           child:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstantWidgets.hight50(context),
              Icon(Icons.cloud_off_outlined,color: AppPalette.buttonColor,size:  40,),
              Text("Unable to complete the request.", style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              Text(state.errorerror, style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
              IconButton(onPressed: (){
                context.read<FetchAllbarberBloc>().add(FetchAllBarbersRequested());
              }, 
              icon: Icon(Icons.refresh_rounded))
            ],
          ),
        )
        );
        }
      return SliverToBoxAdapter(
            child: SizedBox(
              height: widget.screenHeight * .7,
              child: LoadingScreen(
                screenHeight: widget.screenHeight,
                screenWidth: widget.screenWidth,
              ),
            ),
          );
      },
    );
  }
}
