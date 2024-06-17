#include "blockSapling.h"
#include <godot_cpp/core/class_db.hpp>

#include <godot_cpp/variant/utility_functions.hpp>

#include "lookupBlock.h"

using namespace godot;

void BLOCKSAPLING::_bind_methods() {
}

BLOCKSAPLING::BLOCKSAPLING() {

    setTexture("res://block_resources/block_textures/treeSapling.png");

    breakTime = 0.0;

    breakParticleID = 8;

    hasCollision = false;

    lightMultiplier = 1.0;

    rotateTextureToGravity = true;

    connectTexturesToMe = false;

    itemToDrop = 7;

}


BLOCKSAPLING::~BLOCKSAPLING() {
}

Dictionary BLOCKSAPLING::onTick(int x, int y, PLANETDATA *planet, int dir){
    Dictionary changes = {};


    int timeAlive = planet->getGlobalTick() - planet->getTimeData(x,y);

    Vector2i BREAK = Vector2i(Vector2(0,1).rotated(acos(0.0)*dir));
    int whatsBelowMe = planet->getTileData(BREAK.x + x,BREAK.y + y);
    if( !lookup->hasCollision(whatsBelowMe) ){
        changes[Vector2i(x,y)] = -1;
        return changes;

    }


    if (timeAlive > 4000){


        int treeHeight = (std::rand() % 10) + 4; // ( random % variation ) + minimum

        for(int i = 0; i < treeHeight; i++){

            Vector2 poo = Vector2(0,-i).rotated(acos(0.0)*dir);

            changes[Vector2i(Vector2(x+poo.x,y+poo.y))] = 8;


        }

        Vector2 pee = Vector2(0,-treeHeight).rotated(acos(0.0)*dir);

        int side = std::rand() % 2; // either 0 or 1

        if (side == 1){
            int map[] = {0,9,9,0,0,9,9,12,10,0,9,12,12,8,8,9,9,9,12,11,0,9,9,9,0};

            for(int leafX = 0; leafX < 5; leafX++){
                for(int leafY = 0; leafY < 5; leafY++){

                    int getFromMap = (leafX * 5) + leafY;
                    Vector2 leafVec = Vector2(leafX-2,leafY-2).rotated(acos(0.0)*dir);
                    Vector2i coolPos = Vector2i(Vector2(x+pee.x+leafVec.x,y+pee.y+leafVec.y));
                    
                    int existingTile = planet->getTileData(coolPos.x,coolPos.y);

                    if (existingTile < 2 || existingTile == 10 || existingTile == 11){

                        if ( lookup->hasCollision(map[getFromMap]) ){continue;}

                        changes[coolPos] = map[getFromMap];
                    
                    }
                    
                }
            }

        }else{

            int map[] = {0,9,9,9,0,9,9,9,12,10,9,12,12,8,8,9,9,12,11,0,0,9,9,0,0};

            for(int leafX = 0; leafX < 5; leafX++){
                for(int leafY = 0; leafY < 5; leafY++){

                    int getFromMap = (leafX * 5) + leafY;
                    Vector2 leafVec = Vector2(leafX-2,leafY-2).rotated(acos(0.0)*dir);
                    Vector2i coolPos = Vector2i(Vector2(x+pee.x+leafVec.x,y+pee.y+leafVec.y));
                    
                    int existingTile = planet->getTileData(coolPos.x,coolPos.y);

                    if (existingTile < 2 || existingTile == 10 || existingTile == 11){

                        if ( lookup->hasCollision(map[getFromMap]) ){continue;}

                        changes[coolPos] = map[getFromMap];
                    
                    }
                    
                }
            }

        }




    }

    return changes;
}