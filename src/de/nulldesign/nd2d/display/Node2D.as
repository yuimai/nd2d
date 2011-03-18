/*
 *
 *  ND2D - A Flash Molehill GPU accelerated 2D engine
 *
 *  Author: Lars Gerckens
 *  Copyright (c) nulldesign 2011
 *  Repository URL: http://github.com/nulldesign/nd2d
 *
 *
 *  Licence Agreement
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 * /
 */

package de.nulldesign.nd2d.display {
    import de.nulldesign.nd2d.materials.BlendModePresets;
    import de.nulldesign.nd2d.utils.NodeBlendMode;

    import flash.display3D.Context3D;
    import flash.events.EventDispatcher;
    import flash.events.MouseEvent;
    import flash.geom.Matrix3D;
    import flash.geom.Point;
    import flash.geom.Vector3D;

    /**
     * Dispatched when a user presses and releases the main button of the user's pointing device over the same Node2D.
     * @eventType flash.events.MouseEvent.CLICK
     */
    [Event(name="click", type="flash.events.MouseEvent")]

    /**
     * Dispatched when a user presses the pointing device button over an Node2D instance.
     * @eventType flash.events.MouseEvent.MOUSE_DOWN
     */
    [Event(name="mouseDown", type="flash.events.MouseEvent")]

    /**
     * Dispatched when a user moves the pointing device while it is over an Node2D.
     * @eventType flash.events.MouseEvent.MOUSE_MOVE
     */
    [Event(name="mouseMove", type="flash.events.MouseEvent")]

    /**
     * Dispatched when a user releases the pointing device button over an Node2D instance.
     * @eventType flash.events.MouseEvent.MOUSE_UP
     */
    [Event(name="mouseUp", type="flash.events.MouseEvent")]

    /**
     * Dispatched when the user moves a pointing device over an Node2D instance.
     * @eventType flash.events.MouseEvent.MOUSE_OVER
     */
    [Event(name="mouseOver", type="flash.events.MouseEvent")]

    /**
     * Dispatched when the user moves a pointing device away from an Node2D instance.
     * @eventType flash.events.MouseEvent.MOUSE_OUT
     */
    [Event(name="mouseOut", type="flash.events.MouseEvent")]

    /**
     * <p>Basic 2D object. All drawable objects must extend Node2D</p>
     * A Node2D has two methods that are called during rendering:
     * <ul>
     * <li>step - Update the node's position here</li>
     * <li>draw - Your rendering code goes here</li>
     * </ul>
     */

    public class Node2D extends EventDispatcher {

        /**
         * @private
         */
        public var modelMatrix:Matrix3D = new Matrix3D();

        /**
         * @private
         */
        public var modelViewMatrix:Matrix3D = new Matrix3D();

        /**
         * @private
         */
        public var refreshPosition:Boolean = true;

        /**
         * @private
         */
        public var refreshColors:Boolean = true;

        public var children:Vector.<Node2D> = new Vector.<Node2D>();
        public var parent:Node2D;

        public var vx:Number = 0.0;
        public var vy:Number = 0.0;

        public var blendMode:NodeBlendMode = BlendModePresets.NORMAL;

        public var mouseEnabled:Boolean = false;

        private var localMouse:Vector3D;
        private var mouseInNode:Boolean = false;
        private var clipSpaceMatrix:Matrix3D = new Matrix3D();

        /**
         * @private
         */
        protected var _width:Number;

        public function get width():Number {
            return _width;
        }

        /**
         * @private
         */
        protected var _height:Number;

        public function get height():Number {
            return _height;
        }

        private var _visible:Boolean = true;

        public function get visible():Boolean {
            return _visible;
        }

        public function set visible(value:Boolean):void {
            _visible = value;
        }

        private var _alpha:Number = 1.0;

        public function set alpha(value:Number):void {
            _alpha = value;
            refreshColors = true;
            visible = alpha > 0.0;
        }

        public function get alpha():Number {
            return _alpha;
        }

        /**
         * @private
         */
        protected var _a:Number = 1.0;

        public function get a():Number {
            return _a;
        }

        /**
         * @private
         */
        protected var _r:Number = 1.0;

        public function get r():Number {
            return _r;
        }

        /**
         * @private
         */
        protected var _g:Number = 1.0;

        public function get g():Number {
            return _g;
        }

        /**
         * @private
         */
        protected var _b:Number = 1.0;

        public function get b():Number {
            return _b;
        }

        private var _tint:Number = 0xFFFFFF;

        public function set tint(value:Number):void {
            _tint = value;
            refreshColors = true;
        }

        public function get tint():Number {
            return _tint;
        }

        private var _scaleX:Number = 1.0;

        public function set scaleX(value:Number):void {
            _scaleX = value;
            refreshPosition = true;
        }

        public function get scaleX():Number {
            return _scaleX;
        }

        private var _scaleY:Number = 1.0;

        public function set scaleY(value:Number):void {
            _scaleY = value;
            refreshPosition = true;
        }

        public function get scaleY():Number {
            return _scaleY;
        }

        private var _x:Number = 0.0;

        public function set x(value:Number):void {
            _x = value;
            position.x = x;
            refreshPosition = true;
        }

        public function get x():Number {
            return _x;
        }

        private var _y:Number = 0.0;

        public function set y(value:Number):void {
            _y = value;
            position.y = y;
            refreshPosition = true;
        }

        public function get y():Number {
            return _y;
        }

        private var _position:Point = new Point(0.0, 0.0);

        public function get position():Point {
            return _position;
        }

        public function set position(value:Point):void {
            _position = value;
            x = _position.x;
            y = _position.y;
        }

        private var _pivot:Point = new Point(0.0, 0.0);

        public function get pivot():Point {
            return _pivot;
        }

        public function set pivot(value:Point):void {
            _pivot = value;
            refreshPosition = true;
        }

        private var _rotation:Number = 0.0;

        public function set rotation(value:Number):void {
            _rotation = value;
            refreshPosition = true;
        }

        public function get rotation():Number {
            return _rotation;
        }

        private var _mouseX:Number;

        public function get mouseX():Number {
            return _mouseX;
        }

        private var _mouseY:Number;

        public function get mouseY():Number {
            return _mouseY;
        }

        public function get numTris():uint {
            return 0;
        }

        public function get numChildren():uint {
            return children.length;
        }

        public function Node2D() {
        }

        /**
         * @private
         */
        protected function refreshMatrix():void {
            refreshPosition = false;
            modelMatrix.identity();
            modelMatrix.appendTranslation(-pivot.x, -pivot.y, 0);
            modelMatrix.appendScale(scaleX, scaleY, 1.0);
            modelMatrix.appendRotation(rotation, Vector3D.Z_AXIS);
            modelMatrix.appendTranslation(x, y, 0.0);
        }

        /**
         * @private
         */
        protected function updateColors():void {

            refreshColors = false;

            _r = (tint >> 16) / 255.0;
            _g = (tint >> 8 & 255) / 255.0;
            _b = (tint & 255) / 255.0;
            _a = alpha;

            if(parent) {
                _r *= parent.r;
                _g *= parent.g;
                _b *= parent.b;
                _a *= parent.a;
            }
        }

        /**
         * @private
         */
        internal function drawNode(context:Context3D, camera:Camera2D):void {

            if(!visible) {
                return;
            }

            if(refreshPosition) {
                refreshMatrix();
            }

            modelViewMatrix.identity();
            modelViewMatrix.append(modelMatrix);

            if(parent) {
                modelViewMatrix.append(parent.modelViewMatrix);
            }

            draw(context, camera);

            for each(var child:Node2D in children) {
                child.drawNode(context, camera);
            }
        }

        /**
         * @private
         */
        internal function processMouseEvents(mousePosition:Vector3D, mouseEventType:String, camera:Camera2D):void {

            if(mouseEnabled && mouseEventType) {
                // transform mousepos to local coordinate system
                clipSpaceMatrix.identity();
                clipSpaceMatrix.append(modelViewMatrix);
                clipSpaceMatrix.append(camera.getProjectionMatrix());
                clipSpaceMatrix.invert();

                localMouse = clipSpaceMatrix.transformVector(mousePosition);
                localMouse.w = 1.0 / localMouse.w;
                localMouse.x /= localMouse.w;
                localMouse.y /= localMouse.w;
                localMouse.z /= localMouse.w;

                _mouseX = localMouse.x;
                _mouseY = localMouse.y;

                if(isNaN(width) || isNaN(height)) return;

                var oldMouseInNodeState:Boolean = mouseInNode;
                mouseInNode = (localMouse.x >= -width / 2.0 && localMouse.x <= width / 2.0 && localMouse.y >= -height / 2.0 && localMouse.y <= height / 2.0);

                if(mouseInNode) {
                    if(!oldMouseInNodeState) {
                        dispatchMouseEvent(MouseEvent.MOUSE_OVER);
                    }
                    dispatchMouseEvent(mouseEventType);
                } else if(oldMouseInNodeState && !mouseInNode) {
                    dispatchMouseEvent(MouseEvent.MOUSE_OUT);
                }
            }

            for each(var child:Node2D in children) {
                child.processMouseEvents(mousePosition, mouseEventType, camera);
            }
        }

        /**
         * @private
         */
        internal function stepNode(t:Number):void {

            step(t);

            // TODO update local mouse! ??
            for each(var child:Node2D in children) {
                child.stepNode(t);
            }
        }

        private function dispatchMouseEvent(mouseEventType:String):void {
            dispatchEvent(new MouseEvent(mouseEventType, true, false, localMouse.x, localMouse.y, null, false, false,
                                         false, (mouseEventType == MouseEvent.MOUSE_DOWN), 0));
        }

        protected function draw(context:Context3D, camera:Camera2D):void {
            // overwrite in extended classes
        }

        protected function step(t:Number):void {
            // overwrite in extended classes
        }

        public function addChild(child:Node2D):void {
            addChildAt(child, children.length);
        }

        public function addChildAt(child:Node2D, idx:uint):void {
            child.parent = this;
            children.splice(idx, 0, child);
        }

        public function removeChild(child:Node2D):void {

            var idx:int = children.indexOf(child);

            if(idx >= 0) {
                removeChildAt(idx);
            }
        }

        public function removeChildAt(idx:uint):void {
            if(idx < children.length) {
                children[idx].parent = null;
                children.splice(idx, 1);
            }
        }

        public function getChildIndex(child:Node2D):int {
            return children.indexOf(child);
        }

        public function swapChildren(child1:Node2D, child2:Node2D):void {
            var idx1:uint = getChildIndex(child1);
            var idx2:uint = getChildIndex(child2);
            children[idx1] = child2;
            children[idx2] = child1;
        }

        public function removeAllChildren():void {
            while(children.length > 0) {
                removeChildAt(0);
            }
        }
    }
}