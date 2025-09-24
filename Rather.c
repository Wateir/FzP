#include <stdio.h>
#include <stdlib.h>
#include <alpm.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <nom_du_paquet>\n", argv[0]);
        return 1;
    }

    const char *pkgname = argv[1];
    const char *root = "/";
    const char *dbpath = "/var/lib/pacman";

    alpm_handle_t *handle = alpm_initialize(root, dbpath, NULL);
    if (!handle) {
        fprintf(stderr, "Erreur: impossible d'initialiser libalpm.\n");
        return 1;
    }

    alpm_db_t *localdb = alpm_get_localdb(handle);
    alpm_pkg_t *pkg = alpm_db_get_pkg(localdb, pkgname);

    if (!pkg) {
        fprintf(stderr, "Erreur: paquet '%s' introuvable.\n", pkgname);
        alpm_release(handle);
        return 1;
    }

    // Affichage des informations principales
    printf("Name            : %s\n", alpm_pkg_get_name(pkg));
    printf("Version         : %s\n", alpm_pkg_get_version(pkg));
    printf("Description     : %s\n", alpm_pkg_get_desc(pkg));
    printf("Architecture    : %s\n", alpm_pkg_get_arch(pkg));
    printf("URL             : %s\n", alpm_pkg_get_url(pkg));
    
    // Licences
    printf("Licenses        : ");
    for (alpm_list_t *i = alpm_pkg_get_licenses(pkg); i; i = i->next) {
        printf("%s ", (char *)i->data);
    }
    printf("\n");

    // Groupes
    alpm_list_t *groups = alpm_pkg_get_groups(pkg);
    printf("Groups          : ");
    if (groups) {
        for (alpm_list_t *i = groups; i; i = i->next) {
            printf("%s ", (char *)i->data);
        }
    } else {
        printf("None");
    }
    printf("\n");

    // Provides
    printf("Provides        : ");
    alpm_list_t *provides = alpm_pkg_get_provides(pkg);
    if (provides) {
        for (alpm_list_t *i = provides; i; i = i->next) {
            printf("%s ", alpm_dep_compute_string((alpm_depend_t *)i->data));
        }
    } else {
        printf("None");
    }
    printf("\n");

    // Dépendances
    printf("Depends On      : ");
    alpm_list_t *depends = alpm_pkg_get_depends(pkg);
    if (depends) {
        for (alpm_list_t *i = depends; i; i = i->next) {
            printf("%s ", alpm_dep_compute_string((alpm_depend_t *)i->data));
        }
    } else {
        printf("None");
    }
    printf("\n");

    // Optional dependencies
    printf("Optional Deps   : ");
    alpm_list_t *optdeps = alpm_pkg_get_optdepends(pkg);
    if (optdeps) {
        for (alpm_list_t *i = optdeps; i; i = i->next) {
            alpm_depend_t *dep = (alpm_depend_t *)i->data;
            printf("%s: %s [installed]\n", dep->name, dep->desc ? dep->desc : "");
        }
    } else {
        printf("None\n");
    }

    // Required By
    printf("Required By     : ");
    alpm_list_t *required_by = alpm_pkg_compute_requiredby(pkg);
    if (required_by) {
        for (alpm_list_t *i = required_by; i; i = i->next) {
            printf("%s ", (char *)i->data);
        }
        alpm_list_free(required_by);
    } else {
        printf("None");
    }
    printf("\n");

    // Optional For
    printf("Optional For    : ");
    alpm_list_t *optional_for = alpm_pkg_compute_optionalfor(pkg);
    if (optional_for) {
        for (alpm_list_t *i = optional_for; i; i = i->next) {
            printf("%s ", (char *)i->data);
        }
        alpm_list_free(optional_for);
    } else {
        printf("None");
    }
    printf("\n");

    printf("Conflicts With  : None\n"); // À remplir si besoin
    printf("Replaces        : None\n"); // Idem

    // Taille
    printf("Installed Size  : %.2f MiB\n", alpm_pkg_get_isize(pkg) / (1024.0 * 1024.0));

    // Packager
    printf("Packager        : %s\n", alpm_pkg_get_packager(pkg));
    
    // Dates
    time_t build_date = alpm_pkg_get_builddate(pkg);
    time_t install_date = alpm_pkg_get_installdate(pkg);
    printf("Build Date      : %s", ctime(&build_date));
    printf("Install Date    : %s", ctime(&install_date));

    // Raison de l'installation
    alpm_pkgreason_t reason = alpm_pkg_get_reason(pkg);
    printf("Install Reason  : %s\n", reason == ALPM_PKG_REASON_EXPLICIT ? "Explicitly installed" : "Installed as a dependency");

    // Script
    printf("Install Script  : %s\n", alpm_pkg_has_scriptlet(pkg) ? "Yes" : "No");

    // Validation
    printf("Validated By    : %s\n",
           alpm_pkg_get_validation(pkg) & ALPM_PKG_VALIDATION_SIGNATURE ? "Signature" : "None");

    // Nettoyage
    alpm_release(handle);
    return 0;
}
