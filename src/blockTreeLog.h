#ifndef BLOCKTREELOG_H
#define BLOCKTREELOG_H

#include "block.h"

namespace godot {

class BLOCKTREELOG : public BLOCK {
	GDCLASS(BLOCKTREELOG, BLOCK)

private:
	

protected:
	static void _bind_methods();

public:
	BLOCKTREELOG();
	~BLOCKTREELOG();

	Dictionary onTick(int x, int y, PLANETDATA *planet, int dir);
	Dictionary onBreak(int x, int y, PLANETDATA *planet, int dir);

};

}

#endif