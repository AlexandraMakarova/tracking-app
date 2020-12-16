part of 'widgets.dart';

class ButtonFollowLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) => this._createButton(context, state),
    );
  }

  Widget _createButton(BuildContext context, MapState state) {
    final mapBloc = context.watch<MapBloc>();

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon(
            state.followLocation
                ? Icons.directions_run
                : Icons.accessibility_new,
            color: Colors.deepPurple[400],
          ),
          onPressed: () {
            mapBloc.add(OnFollowLocation());
          },
        ),
      ),
    );
  }
}
