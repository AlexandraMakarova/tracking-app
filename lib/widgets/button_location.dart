part of 'widgets.dart';

class ButtonLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapBloc = context.watch<MapBloc>();
    final myLocationBloc = context.watch<MyLocationBloc>();

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon(
            Icons.my_location,
            color: Colors.deepPurple[400],
          ),
          onPressed: () {
            final destination = myLocationBloc.state.location;
            mapBloc.moveCamera(destination);
          },
        ),
      ),
    );
  }
}
