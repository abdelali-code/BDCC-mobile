package ma.android.eventchallenge

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Spinner
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout

/**
 * Ecran 4 : OnItemSelected (Spinner)
 */
class MainActivity4 : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main4)

        val activity4 = findViewById<ConstraintLayout>(R.id.activity4)
        val spinner = findViewById<Spinner>(R.id.spinnerVille)
        val resultText = findViewById<TextView>(R.id.textItemSelected)

        val villes = arrayOf("Casablanca", "Rabat", "Marrakech", "Fès", "Mohammedia", "Tanger")
        val adapter = ArrayAdapter(this, android.R.layout.simple_spinner_dropdown_item, villes)
        spinner.adapter = adapter

        spinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                resultText.text = "Ville sélectionnée : ${villes[position]}"
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {}
        }

        activity4.setOnTouchListener(object : OnSwipeTouchListener(this) {
            override fun onSwipeLeft() {
                startActivity(Intent(this@MainActivity4, MainActivity5::class.java))
                overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right)
            }

            override fun onSwipeRight() {
                startActivity(Intent(this@MainActivity4, MainActivity3::class.java))
                overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right)
                finish()
            }
        })
    }
}
