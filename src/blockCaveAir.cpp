#include "blockCaveAir.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void BLOCKCAVEAIR::_bind_methods() {
}

BLOCKCAVEAIR::BLOCKCAVEAIR() {

    setTexture("res://block_resources/block_textures/air.png");

    connectTexturesToMe = false;

    hasCollision = false;

    lightMultiplier = 0.94;
    lightEmmission = 0.0;
    
    isTransparent = true;
    
}


BLOCKCAVEAIR::~BLOCKCAVEAIR() {
}

