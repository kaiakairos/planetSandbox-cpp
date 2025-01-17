#ifndef BLOCKWINDCHIME_H
#define BLOCKWINDCHIME_H

#include "block.h"

namespace godot {

class BLOCKWINDCHIME : public BLOCK {
	GDCLASS(BLOCKWINDCHIME, BLOCK)

private:
	

protected:
	static void _bind_methods();

public:
	BLOCKWINDCHIME();
	~BLOCKWINDCHIME();

	Dictionary onBreak(int x, int y, PLANETDATA *planet, int dir);
	Dictionary onTick(int x, int y, PLANETDATA *planet, int dir);

};

}

#endif