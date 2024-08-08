#include "chunkdraw.h"
#include <godot_cpp/core/class_db.hpp>


using namespace godot;

void CHUNKDRAW::_bind_methods() {
    ClassDB::bind_method(D_METHOD("generateTexturesFromData","planetData","backgroundLayerData","pos","positionLookup","shipchunk"), &CHUNKDRAW::generateTexturesFromData);
    ClassDB::bind_method(D_METHOD("drawLiquid","planetData","pos","shipchunk"), &CHUNKDRAW::drawLiquid);
    ClassDB::bind_method(D_METHOD("tickUpdate","planetDatac","pos"), &CHUNKDRAW::tickUpdate);
    ClassDB::bind_method(D_METHOD("runBreak","planetDatac","pos","x","y","id"), &CHUNKDRAW::runBreak);
    ClassDB::bind_method(D_METHOD("getBlockDictionary","id"), &CHUNKDRAW::getBlockDictionary);
    ClassDB::bind_method(D_METHOD("scanBlockOpen","planetDATAC","x","y","dir"), &CHUNKDRAW::scanBlockOpen);
    ClassDB::bind_method(D_METHOD("returnLookup"), &CHUNKDRAW::returnLookup);
    ADD_SIGNAL(MethodInfo("chunkDrawn", PropertyInfo(Variant::OBJECT, "node"), PropertyInfo(Variant::OBJECT, "image"), PropertyInfo(Variant::OBJECT, "backImage")));
    ADD_SIGNAL(MethodInfo("attemptSpawnEnemy", PropertyInfo(Variant::OBJECT, "planetData") , PropertyInfo(Variant::VECTOR2, "tile") , PropertyInfo(Variant::INT, "id") , PropertyInfo(Variant::INT, "blockSide") ));
}

CHUNKDRAW::CHUNKDRAW() {
	time_passed = 0.0;
    cock = memnew(LOOKUPBLOCK);
    bitm = memnew(BitMap);

    getBorderImage("res://items/border.png");
    getWaterImage("res://items/water.png");


}

CHUNKDRAW::~CHUNKDRAW() {
	// Add your cleanup here.
}

Dictionary CHUNKDRAW::getBlockDictionary(int id){
    Dictionary blockData = cock->getBlockData(id);
    return blockData;
}

Array CHUNKDRAW::generateTexturesFromData(PLANETDATA *planet,Vector2i pos,Node *body,Ref<Shape2D> shape,bool shipChunk){
    Ref<Image> img = Image::create(64, 64, false, Image::FORMAT_RGBA8);
    Ref<Image> backImg = Image::create(64, 64, false, Image::FORMAT_RGBA8);
    Ref<Image> animImg = Image::create(192, 64, false, Image::FORMAT_RGBA8);
    
    Array images;
    for (int sect = 0; sect < 4; sect++){

        Ref<Image> colliderImg = Image::create(16, 64, false, Image::FORMAT_RGBA8);
        colliderImg->fill(Color::hex(0x00000000));

        for (int x = 0; x < 2; x++){
            for (int y = 0; y < 8; y++){
                
                Vector2 imgPos = Vector2i(((sect*2) + x)*8,y*8);
                int worldX = (sect*2) + x +(pos.x*8);
                int worldY = y+(pos.y*8);

                int planetSize = planet->planetSize; // GETS PASSED IN

                int blockSide = planet->getPositionLookup(worldX,worldY);

                int blockID = planet->getTileData(worldX,worldY);
                int backBlockID = planet->getBGData(worldX,worldY);

                int blockInfo = planet->getInfoData(worldX,worldY);

                // draw main tile
                if (blockID>1){
                    
                    Ref<Image> blockImg = cock->getTextureImage(blockID); // get block texture
                    Ref<Image> individualBlock = Image::create(8, 8, false, Image::FORMAT_RGBA8);
                    
                    bool rotate = cock->isGravityRotate(blockID);
                    int s = rotate; // make sure connected texture doesn't always rotate
                    
                    int frame = 0;
                    if( cock->isConnectedTexture(blockID) ){ frame = scanBlockOpen(planet,worldX,worldY,blockSide * s); }
                    if( cock->isMultitile(blockID) ){ frame = blockInfo * 8; }
                    Rect2i blockRect = Rect2i(frame,0,8,8);
                    individualBlock = blockImg->get_region(blockRect);

                    if (rotate){ 
                        for(int g = 0; g < blockSide; g++){
                            individualBlock->rotate_90(ClockDirection::CLOCKWISE);
                        }
                    }
                    
                    if( cock->isAnimated(blockID) ){
                        // is animated texture
                        animImg->blend_rect(individualBlock, Rect2i(0,0,8,8), imgPos); 
                        
                        
                        for(int i = 1; i < 3; i++){
                            blockRect = Rect2i(frame,8*i,8,8);
                            individualBlock = blockImg->get_region(blockRect);

                            if (rotate){ 
                                for(int g = 0; g < blockSide; g++){
                                    individualBlock->rotate_90(ClockDirection::CLOCKWISE);
                                }
                            }
                            animImg->blend_rect(individualBlock, Rect2i(0,0,8,8), imgPos + Vector2i(64 * i,0));
                        }

                    
                    }
                    else{ 
                    
                        img->blend_rect(individualBlock, Rect2i(0,0,8,8), imgPos); 
                    
                    }


                    
                    if( cock->hasCollision(blockID) ) {
                        colliderImg->fill_rect(Rect2i(x*8,y*8,8,8),Color::hex(0xFFFFFFFF));
                    }
                    if( !cock->isTransparent(blockID) ) {
                        continue;
                    }

                }


                // draw background
                // imrpove this so it doesn't have to do that ugly rotate thing

                if (backBlockID>1){
                    
                    Ref<Image> blockImg = cock->getTextureImage(backBlockID);

                    bool rotate = cock->isGravityRotate(backBlockID);
                    if (rotate){ 
                        for(int g = 0; g < blockSide; g++){
                            blockImg->rotate_90(ClockDirection::CLOCKWISE);
                        }
                    }

                    int frame = 0;
                    if( cock->isConnectedTexture(backBlockID) ) { frame = scanBackOpen(planet,worldX,worldY); }
                    Rect2i blockRect = Rect2i(frame,0,8,8);

                    backImg->blend_rect(blockImg, blockRect, imgPos);

                    Vector2i scan = scanForBorder(planet,worldX,worldY);

                    backImg->blend_rect(texImage, Rect2i(scan.x,scan.y,8,8), imgPos);

                    // unrotate it
                    if (rotate){ 
                        for(int g = 0; g < blockSide; g++){
                            blockImg->rotate_90(ClockDirection::COUNTERCLOCKWISE);
                        }
                    }

                
                }

            }
        }

        // Collision Sector Code //

        bitm->create_from_image_alpha(colliderImg, 0.5);
        Array polygons = bitm->opaque_to_polygons( Rect2(Vector2(0 , 0), Vector2(16 , 64) ) , 1.0);

        for( int i = 0; i < polygons.size(); i++ ){
            CollisionPolygon2D *col ;
            col = memnew(CollisionPolygon2D);

            PackedVector2Array cunt = polygons[i];


            col->set_polygon( cunt );
            if(shipChunk){
                col->set_position( Vector2( sect*16.0 , 0.0 ) + (pos*64) - Vector2( 128 , 128 ) ); //replace last vector with ship chunk size * 32
                images.append(col);
            }else{
                col->set_position( Vector2( sect*16.0 , 0.0 ) );
            }
            body->add_child(col);

        }

    }


    images.append(img);
    images.append(backImg);
    images.append(animImg);


   return images;

}

Array CHUNKDRAW::drawLiquid(PLANETDATA *planet,Vector2i pos,bool shipChunk){

    Ref<Image> waterImg = Image::create(64, 64, false, Image::FORMAT_RGBA8);
    
    Array images;
    
    for (int x = 0; x < 8; x++){
        for (int y = 0; y < 8; y++){
            
            Vector2 imgPos = Vector2i(x*8,y*8);
            int worldX = x+(pos.x*8);
            int worldY = y+(pos.y*8);

            int blockSide = planet->getPositionLookup(worldX,worldY);

            Vector2i goop = getWaterImgPos(planet,worldX,worldY,blockSide);
            waterImg->blend_rect(watertexImage, Rect2i(goop.x * 8,goop.y * 8,8,8), imgPos);
        }
    }

    images.append(waterImg);
    return images;

}

Array CHUNKDRAW::tickUpdate(PLANETDATA *planet,Vector2i pos,bool onScreen,float daylight){

    Array collectedChanges;
    bool shouldRedrawLiquid = false;

    for(int x = 0; x < 8; x++){
        for(int y = 0; y < 8; y++){
            int worldX = x+(pos.x*8);
            int worldY = y+(pos.y*8);

            int planetSize = planet->planetSize; // GETS PASSED IN
            
            int blockID = planet->getTileData(worldX,worldY);
            int bgID = planet->getBGData(worldX,worldY);

            int blockSide = planet->getPositionLookup(worldX,worldY);


            collectedChanges.append( cock->runOnTick(worldX,worldY,planet,blockSide,blockID) );

            // SIMULATE WATER //

            double water = planet->getWaterData(worldX,worldY);
            double beginningWater = water;
            
            if (water < 0.01){ // skip if water level is too low
                if(water > -0.01){
                    planet->setWaterData(worldX,worldY,0.0);
                }else{
                    planet->setWaterData(worldX,worldY,std::abs(water));
                }
            }else if(cock->hasCollision( blockID )){
                planet->setWaterData(worldX,worldY,0.0);
                shouldRedrawLiquid = true;
            }else{
                Vector2i blockBelow = Vector2i(worldX,worldY) + Vector2i( Vector2(0,1).rotated( acos(0.0) * blockSide ) );
                bool belowHasCollider = cock->hasCollision( planet->getTileData(blockBelow.x,blockBelow.y) );
                double waterLevelBelow = std::abs(planet->getWaterData(blockBelow.x,blockBelow.y));

                if (belowHasCollider){
                    waterLevelBelow = 20.0;
                }

                double combined = water + waterLevelBelow;

                if (combined < 1.0){
                    planet->setWaterData(worldX,worldY,0.0);
                    planet->setWaterData(blockBelow.x,blockBelow.y,-combined);
                }
                else{
                    if (!belowHasCollider){
                    planet->setWaterData(blockBelow.x,blockBelow.y,-1.0);
                    planet->setWaterData(worldX,worldY,(combined - 1.0) * -1);
                    
                    water = combined - 1.0;
                    }

                    Vector2i blockRight = Vector2i(worldX,worldY) + Vector2i( Vector2(1,0).rotated( acos(0.0) * blockSide ) );
                    Vector2i blockLeft = Vector2i(worldX,worldY) + Vector2i( Vector2(-1,0).rotated( acos(0.0) * blockSide ) );

                    int rightHasCollider = cock->hasCollision( planet->getTileData(blockRight.x,blockRight.y) );
                    int leftHasCollider = cock->hasCollision( planet->getTileData(blockLeft.x,blockLeft.y) );

                    int coolValue = rightHasCollider + ( leftHasCollider * 2 );
                    if(coolValue == 2){
                        double waterLevelRight = std::abs(planet->getWaterData(blockRight.x,blockRight.y));
                        double coolAverage = (waterLevelRight + water)/2.0;
                        planet->setWaterData(worldX,worldY,-coolAverage);
                        planet->setWaterData(blockRight.x,blockRight.y,-coolAverage);
                    }
                    else if(coolValue == 1){
                        double waterLevelLeft = std::abs(planet->getWaterData(blockLeft.x,blockLeft.y));
                        double coolAverage = (waterLevelLeft + water)/2.0;
                        planet->setWaterData(worldX,worldY,-coolAverage);
                        planet->setWaterData(blockLeft.x,blockLeft.y,-coolAverage);
                    }
                    else if(coolValue == 0){
                        double waterLevelRight = std::abs(planet->getWaterData(blockRight.x,blockRight.y));
                        double waterLevelLeft = std::abs(planet->getWaterData(blockLeft.x,blockLeft.y));
                        double coolAverage = (waterLevelRight + waterLevelLeft + water)/3.0;
                        planet->setWaterData(worldX,worldY,-coolAverage);
                        planet->setWaterData(blockLeft.x,blockLeft.y,-coolAverage);
                        planet->setWaterData(blockRight.x,blockRight.y,-coolAverage);
                    }
                }
            
            }

            water = planet->getWaterData(worldX,worldY);
            if( std::abs( std::abs(beginningWater) - std::abs(water) ) >= 0.01) {
                shouldRedrawLiquid = true;
            } else if( std::rand() % 50 == 0 ){  shouldRedrawLiquid = true; }


            // SIMULATE LIGHT //

            double cLight = planet->getLightData(worldX,worldY);
            if (cLight < 0.0){
                planet->setLightData(worldX,worldY,std::abs(cLight));
                continue;
            }

            double lightL = std::abs(planet->getLightData(worldX - 1,worldY));

            double lightR = std::abs(planet->getLightData(worldX + 1,worldY));
                
            double lightB = std::abs(planet->getLightData(worldX,worldY + 1));

            double lightT = std::abs(planet->getLightData(worldX,worldY - 1));

            //average light values
            double mutliplier = cock->getLightMultiplier(blockID);

            if (std::abs(water)> 0.2){
                mutliplier = 0.75;
            }


            double avgn = (lightL + lightR + lightB + lightT)/4.0;
            double newLight = ( std::max({ lightB , lightL , lightR , lightT }) + avgn  ) * mutliplier * 0.5;
            double lightEmmission = cock->getLightEmmission(blockID);

            if(blockID == 0){
                lightEmmission = 5.0 * daylight;
                if(bgID > 1){
                    lightEmmission = 0.0;
                }
            }

            if (std::abs(water)> 0.2){
                lightEmmission = 0.0;
            }

            newLight = std::max(newLight,lightEmmission);

            planet->setLightData(worldX,worldY,newLight);

            /////////////////////////////

        }

   }

    collectedChanges.append(shouldRedrawLiquid);

    return collectedChanges;
        
}



int CHUNKDRAW::scanBlockOpen(PLANETDATA *planet,int x,int y,int dir){
	int openL = 1;
	int openR = 2;
	int openT = 4;
	int openB = 8;
	//what the fuck is this

    Vector2i L = Vector2i( Vector2(-1,0).rotated(acos(0.0)*dir)  );

    int blockID = planet->getTileData(x+L.x,y+L.y);
    int connectTexturesToMe = !cock->isTextureConnector(blockID);
    openL = 1 * connectTexturesToMe;

    Vector2i R = Vector2i( Vector2(1,0).rotated(acos(0.0)*dir)  );
    blockID = planet->getTileData(x+R.x,y+R.y);
    connectTexturesToMe = !cock->isTextureConnector(blockID);
    openR = 2 * connectTexturesToMe;

    Vector2i T = Vector2i( Vector2(0,-1).rotated(acos(0.0)*dir)  );
    blockID = planet->getTileData(x+T.x,y+T.y);
    connectTexturesToMe = !cock->isTextureConnector(blockID);
    openT = 4 * connectTexturesToMe;

    Vector2i B = Vector2i( Vector2(0,1).rotated(acos(0.0)*dir)  );
    blockID = planet->getTileData(x+B.x,y+B.y);
    connectTexturesToMe = !cock->isTextureConnector(blockID);
    openB = 8 * connectTexturesToMe;

	return (openL + openR + openT + openB) * 8;
}

int CHUNKDRAW::scanBackOpen(PLANETDATA *planet,int x,int y){
	int openL = 1;
	int openR = 2;
	int openT = 4;
	int openB = 8;
	//what the fuck is this

    int blockID = planet->getBGData(x-1,y);
    int connectTexturesToMe = !cock->isTextureConnector(blockID);
    openL = 1 * connectTexturesToMe;

    blockID = planet->getBGData(x+1,y);
    connectTexturesToMe = !cock->isTextureConnector(blockID);
    openR = 2 * connectTexturesToMe;


    blockID = planet->getBGData(x,y-1);
    connectTexturesToMe = !cock->isTextureConnector(blockID);
    openT = 4 * connectTexturesToMe;

    blockID = planet->getBGData(x,y+1);
    connectTexturesToMe = !cock->isTextureConnector(blockID);
    openB = 8 * connectTexturesToMe;

	return (openL + openR + openT + openB) * 8;
}

Vector2i CHUNKDRAW::scanForBorder(PLANETDATA *planet,int x,int y){
	int openL = 1;
	int openR = 2;
	int openT = 4;
	int openB = 8;
	
    int openTL = 1;
	int openTR = 2;
	int openBL = 4;
	int openBR = 8;


    // Straight Directionals
    int blockID = planet->getBGData(x-1,y);
    int connectTexturesToMe = blockID < 2;
    openL = 1 * connectTexturesToMe;

    blockID = planet->getBGData(x+1,y);
    connectTexturesToMe = blockID < 2;
    openR = 2 * connectTexturesToMe;

    blockID = planet->getBGData(x,y-1);
    connectTexturesToMe = blockID < 2;
    openT = 4 * connectTexturesToMe;

    blockID = planet->getBGData(x,y+1);
    connectTexturesToMe = blockID < 2;
    openB = 8 * connectTexturesToMe;

    // Diagonal Directionals
    blockID = planet->getBGData(x-1,y-1);
    connectTexturesToMe = blockID < 2;
    openTL = 1 * connectTexturesToMe;

    blockID = planet->getBGData(x+1,y-1);
    connectTexturesToMe = blockID < 2;
    openTR = 2 * connectTexturesToMe;

    blockID = planet->getBGData(x-1,y+1);
    connectTexturesToMe = blockID < 2;
    openBL = 4 * connectTexturesToMe;

    blockID = planet->getBGData(x+1,y+1);
    connectTexturesToMe = blockID < 2;
    openBR = 8 * connectTexturesToMe;

	return Vector2i((openL + openR + openT + openB) * 8 , (openTL + openTR + openBL + openBR) * 8 ) ;
}

Dictionary CHUNKDRAW::runBreak(PLANETDATA *planet,Vector2i pos,int x, int y, int blockID){

    int blockSide = planet->getPositionLookup(x,y);

    return cock->runOnBreak(x,y,planet,blockSide,blockID);
        
}

void CHUNKDRAW::getBorderImage( const char* file ) {
    ResourceLoader rl;
    texture = rl.load(file);

    texImage = texture->get_image();
    texImage->convert(Image::FORMAT_RGBA8);

}

void CHUNKDRAW::getWaterImage( const char* file ) {
    ResourceLoader rl;
    watertexture = rl.load(file);

    watertexImage = watertexture->get_image();
    watertexImage->convert(Image::FORMAT_RGBA8);

}

Vector2i CHUNKDRAW::getWaterImgPos(PLANETDATA *planet,int x,int y, int blockSide){
    Vector2i posi = Vector2i(0,0);
    double water = planet->getWaterData(x,y);
   // if(abs(water) < 0.05){ return posi; }

    Vector2i blockBelow = Vector2i(x,y) + Vector2i( Vector2(0,1).rotated( acos(0.0) * blockSide ) );
    int sideOfBelow = planet->getPositionLookup(blockBelow.x,blockBelow.y);

   
    posi.x = std::ceil(std::abs(water * 8.0));
    
    Vector2i tileABOVE = Vector2i(x,y) + Vector2i( Vector2(0,-1).rotated( acos(0.0) * blockSide ) );
    double waterlevelabove = planet->getWaterData(tileABOVE.x,tileABOVE.y);
    if (abs(waterlevelabove) > 0.0 && abs(water) > 0.0){
        posi.x = 9;
    }
    
    
    if(sideOfBelow == blockSide){
        posi.y = blockSide;
    }else{
        int cornerID = blockSide + (sideOfBelow*2);
        posi.y = blockSide;
        switch(cornerID){
            case 1:
                posi.y = 5;
                break;
            case 5:
                posi.y = 6;
                break;
            case 6:
                posi.y = 4;
                break;
            case 8:
                posi.y = 7;
                break;

        }   
    }
    return posi;
}

LOOKUPBLOCK* CHUNKDRAW::returnLookup(){
    return cock;
}