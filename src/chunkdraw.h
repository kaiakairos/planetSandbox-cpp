#ifndef CHUNKDRAW_H
#define CHUNKDRAW_H

#include <godot_cpp/classes/sprite2d.hpp>
#include <godot_cpp/classes/image.hpp>
#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/classes/texture2d.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/rect2i.hpp>

#include <godot_cpp/classes/static_body2d.hpp>
#include <godot_cpp/classes/collision_shape2d.hpp>
#include <godot_cpp/classes/rectangle_shape2d.hpp>

#include <algorithm>

#include "lookupBlock.h"

namespace godot {

class CHUNKDRAW : public Sprite2D {
	GDCLASS(CHUNKDRAW, Sprite2D)

private:
	double time_passed;
    Array planetData;
	LOOKUPBLOCK *cock;

protected:
	static void _bind_methods();

public:
	CHUNKDRAW();
	~CHUNKDRAW();

    Array generateTexturesFromData(Array planetData,Vector2i pos,Array positionLookup,Node *body,Ref<Shape2D> shape);
	void tickUpdate(Array planetData,Vector2i pos,Array positionLookup,Array lightData);

	int scanBlockOpen(Array planetData,int x,int y,int layer);
	Array getTileFromData(int x, int y, Array planetData);
	int tileInRange(int x, int y, Array planetData);

	void _process(double delta) override;
};

}

#endif