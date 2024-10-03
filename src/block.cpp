#include "block.h"
#include "lookupBlock.h"
#include <godot_cpp/core/class_db.hpp>

#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void BLOCK::_bind_methods() {
}

BLOCK::BLOCK() {
    //Default Variables
    blockID = -1;

    setTexture("res://items/error.png");

    rotateTextureToGravity = false;
    connectedTexture = false;
    connectTexturesToMe = true;

    hasCollision = true;

    lightMultiplier = 0.6;
    lightEmmission = 0.0;

    // -1 drops nothing
    itemToDrop = -1;

    // -1 = particles match texture
    breakParticleID = -1;

    // in seconds
    breakTime = 0.5;

    multitile = false;
    animated = false;

    isTransparent = false;

    miningLevel = 0; // 0 is always mineable, 1 is copper tools, 2 is gold tools, 3 is iron tools...
    soundMaterial = 0; // stone, dirt, wood, sand, cloth, leaves, glass

    setNewVariables();

}

BLOCK::~BLOCK() {
}

void BLOCK::setNewVariables(){
}

void BLOCK::setTexture( const char* file ) {
    ResourceLoader rl;
    if(rl.exists(file)){
        texture = rl.load(file);

        texImage = texture->get_image();
        texImage->convert(Image::FORMAT_RGBA8);
    }

}

Dictionary BLOCK::onTick(int x, int y, PLANETDATA *planet, int dir){
    Dictionary changes = {};
    return changes;
}

Dictionary BLOCK::onBreak(int x, int y, PLANETDATA *planet, int dir){
    Dictionary changes = {};
    return changes;
}

void BLOCK::setLookUp(LOOKUPBLOCK *g){
    lookup = g;

}
