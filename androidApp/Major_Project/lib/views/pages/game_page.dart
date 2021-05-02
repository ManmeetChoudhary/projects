//rebuilding will always restart the game engine, be careful
//maybe the top widget should be stateless?
import 'package:flame/components/sprite_animation_component.dart';
import 'package:flame/extensions/vector2.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/components/parallax_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/material.dart';

class GameProfilePage extends StatefulWidget {
  @override
  _GameProfilePageState createState() => _GameProfilePageState();
}

class _GameProfilePageState extends State<GameProfilePage> {
  MyGame game = MyGame();
  String text  = "test";
  bool paused = false;
  String longtext = "Paragraphs are the building blocks of papers. Many students define paragraphs in terms of length: a paragraph is a group of at least five sentences, a paragraph is half a page long, etc. In reality, though, the unity and coherence of ideas among sentences is what constitutes a paragraph. A paragraph is defined as “a group of sentences or a single sentence that forms a unit” (Lunsford and Connors 116). Length and appearance do not determine whether a section in a paper is a paragraph. For instance, in some styles of writing, particularly journalistic styles, a paragraph can be just one sentence long. Ultimately, a paragraph is a sentence or group of sentences that support one main idea. In this handout, we will refer to this as the “controlling idea,” because it controls what happens in the rest of the paragraph.";
  @override
  void initState() {
    Flame.images.load('rowrow_2.png');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<ScaffoldState>();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            bottom: 500,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: game.widget,
            ),
          ),
          Positioned.fill(
            child: GestureDetector( //button layer
              behavior: HitTestBehavior.deferToChild,
            ),
          ),
          Positioned.fill(
            top:240,
            left:0,
            right:310,
            child: Container(color: Colors.greenAccent,
              child:Padding(padding: const EdgeInsets.all(4),child:ListView(
                  children: [Padding(padding: const EdgeInsets.all(10),child:Container(height: 100,width: 100,child:Text(longtext))), Padding(padding: const EdgeInsets.all(10),child:Container(height: 100,width: 100,child:Text(longtext))), Padding(padding: const EdgeInsets.all(10),child:Container(height: 100,width: 100,child:Text(longtext))), Padding(padding: const EdgeInsets.all(10),child:Container(height: 100,width: 100,child:Text(longtext))), Padding(padding: const EdgeInsets.all(10),child:Container(height: 100,width: 100,child:Text(longtext))), ] ),
              ),
            ),
          ),
          Positioned.fill(
            top: 205,
            left: 100,
            right:100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text('test'),
                  Stack(
                    children: <Widget>[
                      Card(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: SizedBox(
                            height: 130.0,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 80.0, ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Kylo Ren",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child:Text("about")
                                  ),
                                ],
                              ),
                            )),
                      ),
                      Positioned(
                        top: .0,
                        left: 0,
                        right: .0,
                        child: Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 50.0,
                            child: Text("D"),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    color:Colors.lightBlueAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      key: key,
      appBar: AppBar(
        title: const Text('Flutter'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _togglePause()),
    );
  }
  void _togglePause(){
    paused =!paused;
    if (paused){game.resumeEngine(); return;}
    game.pauseEngine(); return;
  }

}
class MyGame extends BaseGame {
  MyGame() {
    final image = Flame.images.fromCache('rowrow_2.png');
    final _animationSpriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(74,70),
    );
    final _animation = _animationSpriteSheet.createAnimation(
        row: 0,
        stepTime: 0.03);
    final images = [
      /*
      ParallaxImage('dwood_1.png'),
      ParallaxImage('dwood_2.png'),
      ParallaxImage('dwood_3.png'),
      ParallaxImage('dwood_4.png'),*/
      ParallaxImage('redawn_1.png'),
      ParallaxImage('redawn_2.png'),
      ParallaxImage('redawn_3.png'),
      ParallaxImage('redawn_4.png'),
      ParallaxImage('redawn_5.png'),
      ParallaxImage('redawn_6.png'),


    ];
    final sprite = SpriteAnimationComponent(Vector2(190,180),_animation);

    final parallaxComponent = ParallaxComponent(
      images,
      baseSpeed: Vector2(0, 0),
      layerDelta: Vector2(100, 0),
    );
    sprite.position = Vector2(-20,85);

    add(parallaxComponent);
    add(sprite);

    //pause bg
    parallaxComponent.layerDelta = Vector2(0,0);

  }
}