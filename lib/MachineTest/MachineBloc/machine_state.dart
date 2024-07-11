class MachineState{
  String? nameFlower;
  String? imagePath;

  MachineState({this.nameFlower, this.imagePath});
}
class LoadedMachineState extends MachineState{
  LoadedMachineState({super.nameFlower,super.imagePath});
}
class LoadingMachineState extends MachineState{}