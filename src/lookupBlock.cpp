#include "lookupBlock.h"

#include "block.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void LOOKUPBLOCK::_bind_methods() {
    ClassDB::bind_method(D_METHOD("getBlockData","id"), &LOOKUPBLOCK::getBlockData);

    ClassDB::bind_method(D_METHOD("isMultitile","id"), &LOOKUPBLOCK::isMultitile);
    ClassDB::bind_method(D_METHOD("isAnimated","id"), &LOOKUPBLOCK::isMultitile);
    ClassDB::bind_method(D_METHOD("hasCollision","id"), &LOOKUPBLOCK::hasCollision);
    ClassDB::bind_method(D_METHOD("isGravityRotate","id"), &LOOKUPBLOCK::isGravityRotate);
    ClassDB::bind_method(D_METHOD("getTextureImage","id"), &LOOKUPBLOCK::getTextureImage);
}

// ADD BLOCKS TO ARRAY IN HERE
LOOKUPBLOCK::LOOKUPBLOCK() {
    
    penis[0] = new BLOCKAIR();
    penis[1] = new BLOCKCAVEAIR();
    penis[2] = new BLOCKSTONE();
    penis[3] = new BLOCKDIRT();
    penis[4] = new BLOCKGRASS();
    penis[5] = new BLOCKCORE();
    penis[6] = new BLOCKPLASMA();
    penis[7] = new BLOCKSAPLING();
    penis[8] = new BLOCKTREELOG();
    penis[9] = new BLOCKLEAVES();
    penis[10] = new BLOCKTREEBRANCHLEFT();
    penis[11] = new BLOCKTREEBRANCHRIGHT();
    penis[12] = new BLOCKTREEBRANCHLEAF();
    penis[13] = new BLOCKWOOD();
    penis[14] = new BLOCKSAND();
    penis[15] = new BLOCKTORCH();
    penis[16] = new BLOCKFURNACE();
    penis[17] = new BLOCKTALLGRASS();
    penis[18] = new BLOCKORECOPPER();
    penis[19] = new BLOCKCHAIR();
    penis[20] = new BLOCKWORKBENCH();
    penis[21] = new BLOCKGLASS();
    penis[22] = new BLOCKDOORCLOSED();
    penis[23] = new BLOCKDOOROPEN();
    penis[24] = new BLOCKOREGOLD();
    penis[25] = new BLOCKLADDER();
    penis[26] = new BLOCKFLOWER();
    penis[27] = new BLOCKOREIRON();
    penis[28] = new BLOCKGRAVEL();
    penis[29] = new BLOCKBARCOPPER();
    penis[30] = new BLOCKBARGOLD();
    penis[31] = new BLOCKBARIRON();
    penis[32] = new BLOCKSTONEBRICK();
    penis[33] = new BLOCKCHEST();
    penis[34] = new BLOCKCHESTLOOT();
    penis[35] = new BLOCKSOIL();

    
    for(BLOCK *i : penis){ // i increase automatically !
        i->setLookUp(this);
    }
}

LOOKUPBLOCK::~LOOKUPBLOCK() {
}

Dictionary LOOKUPBLOCK::getBlockData(int id){
    Dictionary data ={};

    BLOCK* g = penis[id];
    data["texture"] = g->texture;
    data["rotateTextureToGravity"] = g->rotateTextureToGravity;
    data["connectTexturesToMe"] = g->connectTexturesToMe;
    data["connectedTexture"] = g->connectedTexture;
    data["hasCollision"] = g->hasCollision;
    data["itemToDrop"] = g->itemToDrop;
    data["breakParticleID"] = g->breakParticleID;
    data["breakTime"]= g->breakTime;
    data["lightMultiplier"] = g->lightMultiplier;
    data["lightEmmission"] = g->lightEmmission;
    data["multitile"] = g->multitile;
    data["animated"] = g->animated;

    return data;
}

bool LOOKUPBLOCK::hasCollision(int id){
    BLOCK* g = penis[id];

    return g->hasCollision;
}

bool LOOKUPBLOCK::isGravityRotate(int id){
    BLOCK* g = penis[id];

    return g->rotateTextureToGravity;
}

bool LOOKUPBLOCK::isConnectedTexture(int id){
    BLOCK* g = penis[id];

    return g->connectedTexture;
}

Ref<Image> LOOKUPBLOCK::getTextureImage(int id){
    BLOCK* g = penis[id];

    return g->texImage;
}


bool LOOKUPBLOCK::isTextureConnector(int id){
    BLOCK* g = penis[id];

    return g->connectTexturesToMe;
}

bool LOOKUPBLOCK::isMultitile(int id){
    BLOCK* g = penis[id];

    return g->multitile;
}

bool LOOKUPBLOCK::isAnimated(int id){
    BLOCK* g = penis[id];

    return g->animated;
}

double LOOKUPBLOCK::getLightMultiplier(int id){
    BLOCK* g = penis[id];

    return g->lightMultiplier;
}

double LOOKUPBLOCK::getLightEmmission(int id){
    BLOCK* g = penis[id];

    return g->lightEmmission;
}

bool LOOKUPBLOCK::isTransparent(int id){
    BLOCK* g = penis[id];

    return g->isTransparent;
}

Dictionary LOOKUPBLOCK::runOnTick(int x, int y, PLANETDATA *planet, int dir, int blockID){
   
    return penis[blockID]->onTick(x,y,planet,dir);

}

Dictionary LOOKUPBLOCK::runOnBreak(int x, int y, PLANETDATA *planet, int dir, int blockID){
   
    return penis[blockID]->onBreak(x,y,planet,dir);

}
