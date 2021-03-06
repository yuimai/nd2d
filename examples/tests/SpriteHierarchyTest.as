/*
 * ND2D - A Flash Molehill GPU accelerated 2D engine
 *
 * Author: Lars Gerckens
 * Copyright (c) nulldesign 2011
 * Repository URL: http://github.com/nulldesign/nd2d
 * Getting started: https://github.com/nulldesign/nd2d/wiki
 *
 *
 * Licence Agreement
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package tests {

    import de.nulldesign.nd2d.display.Scene2D;
    import de.nulldesign.nd2d.display.Sprite2D;
    import de.nulldesign.nd2d.materials.BlendModePresets;
    import de.nulldesign.nd2d.materials.SpriteSheet;

    import flash.display.BitmapData;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class SpriteHierarchyTest extends Scene2D {

        [Embed(source="/assets/crate.jpg")]
        private var spriteTexture:Class;

        [Embed(source="/assets/spritechar2.png")]
        private var spriteTexture2:Class;

        private var s:Sprite2D;
        private var s2:Sprite2D;
        private var s3:Sprite2D;

        public function SpriteHierarchyTest() {

            s = new Sprite2D(new spriteTexture().bitmapData);
            s.mouseEnabled = true;
            s.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
            s.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
            addChild(s);

            s2 = new Sprite2D(new spriteTexture().bitmapData);
            s2.mouseEnabled = true;
            s2.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
            s2.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
            s2.x = 80;
            s2.y = 80;
            s2.scaleX = 0.5;
            s2.scaleY = 0.5;
            s.addChild(s2);

            var bmp:BitmapData = new spriteTexture2().bitmapData;

            var sheet:SpriteSheet = new SpriteSheet(bmp, 24, 32, 5);
            sheet.addAnimation("up", [6, 7, 8], true);
            sheet.playAnimation("up", 0, true);

            s3 = new Sprite2D(sheet);
            s3.mouseEnabled = true;
            s3.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
            s3.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
            s3.scaleX = s3.scaleY = 4.0;
            s2.addChild(s3);

            s3.blendMode = BlendModePresets.NORMAL_PREMULTIPLIED_ALPHA;
        }

        private function mouseOut(event:MouseEvent):void {
            event.target.tint = 0xffffff;
        }

        private function mouseOver(event:MouseEvent):void {
            event.target.tint = Math.random() * 0xffffff;
        }

        override protected function step(elapsed:Number):void {

            //s.x = stage.stageWidth / 2;
            //s.y = stage.stageHeight / 2;
            s.position = new Point(stage.stageWidth / 2, stage.stageHeight / 2);
            //s.alpha = 0.5 + 0.5 * Math.sin(getTimer() / 500);
            s.rotation += 0.1;

            //s.pivot = new Point(Math.sin(getTimer() / 800) * 64, Math.cos(getTimer() / 800) * 64);

            s2.rotation -= 0.5;

            s3.rotation -= 0.5;
        }
    }
}