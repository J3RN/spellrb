#include <ruby.h>

VALUE Spell = Qnil;
VALUE SpellSpell = Qnil;

void Init_Spell();
VALUE method_bigram_compare(VALUE self, VALUE one_bigrams, VALUE two_bigrams);

void Init_Spell() {
	Spell = rb_define_module("Spell");
	SpellSpell = rb_define_class_under(Spell, "Spell");
	rb_define_method(SpellSpell, "bigram_compare", method_bigram_compare, 2);
}

VALUE method_bigram_compare(VALUE self, VALUE one_bigrams, VALUE two_bigrams) {

}
