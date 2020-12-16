part of 'widgets.dart';

class ButtonMyRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapBloc = context.watch<MapBloc>();

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon(
            !mapBloc.state.drawRoute ? Icons.visibility : Icons.visibility_off,
            color: Colors.deepPurple[400],
          ),
          onPressed: () {
            mapBloc.add(OnShowRoute());
          },
        ),
      ),
    );
  }
}
