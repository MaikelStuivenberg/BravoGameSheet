import 'box_color.dart';

class CardBox {
  BoxColor color;
  bool star;
  bool checked = false;
  bool box = false;

  CardBox(this.color, {this.star = false, this.box = false});
}