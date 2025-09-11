#define _XOPEN_SOURCE 700 // NOLINT(*-reserved-identifier)

#include <wchar.h>
#include <notcurses/notcurses.h>

int main() {

    const struct notcurses_options opts = {
        .flags = 0,
    };


    struct notcurses* nc = notcurses_init(&opts, NULL);
    if (!nc) {
        return 1;
    }

    struct ncplane* stdn = notcurses_stdplane(nc);
    ncplane_erase(stdn);
    ncplane_move_yx(stdn, 20, 30);
    ncplane_putstr(stdn, "Hello World !");
    ncplane_perimeter_rounded(stdn, 0, 0, 0);
    ncplane_putstr(stdn, "Hello World !");

    notcurses_render(nc);

    struct ncinput input;

    while (1) {
        const uint32_t id = notcurses_get_blocking(nc, &input);
        if (id == 'q' || id == 'Q') {
            break;
        }
    }

    notcurses_stop(nc);
    return 0;
}
