<?php
namespace console\controllers;

use Yii;
use yii\console\Controller;

use common\models\User;
use common\models\Admin;
use common\models\Banner;
use common\models\Category;
use common\models\Supplier;
use common\models\Product;
use common\models\Payment;

class AdminController extends Controller
{
    public function actionCreate($email, $password, $nom = null, $prenom = null)
    {
        //add a default admin
        $transaction = Yii::$app->db->beginTransaction();
        try {
            $user = new User();
            $admin = new Admin();

            $key = Yii::$app->getSecurity()->generatePasswordHash(microtime(true)*100000);
            $user->last_name =$nom;
            $user->first_name =$prenom;
            $user->email = $email;
            $user->setPassword($password);
            $user->generateAuthKey();
            $user->role = User::SUPER_ADMIN;
            $user->confirm = true;
            $user->status = User::STATUS_ACTIVE;
            $user->save();

            $admin->link('user', $user);
            $admin->save();

            $transaction->commit();

            // //notify
            // $mail = Yii::$app
            //     ->mailer
            //     ->compose(
            //         [
            //         'html' => 'create-application-html',
            //         'text' => 'create-application-text'],
            //         [
            //         'nom' => $nom,
            //         'prenom' => $prenom,
            //         'email' => $email,
            //         'password' => $password,
            //         ]
            //     )
            //     ->setFrom([\Yii::$app->params['noreplyEmail'] => 'noreply'])
            //     ->setTo($email)
            //     ->setSubject(Yii::t('app', 'Informations de votre compte'))
            //     ->send();
            echo "Compte crée\n";
        } catch (\Exception $e) {
            $transaction->rollBack();
            throw $e;
        }
    }

    public function actionSeed()
    {
        $banner = new Banner();
        $banner->path = '/themes/basic2/themes/images/carousel/banner-1.jpg';
        $banner->save();

        $category = new Category();
        $category->name = 'WOMAN';
        $category->makeRoot();

        $category0 = new Category();
        $category0->name = 'MAN';
        $category0->makeRoot();

        $category1 = new Category();
        $category1->name = 'SPORT';
        $category1->makeRoot();

        $category2 = new Category();
        $category2->name = 'HANGBAG';
        $category2->makeRoot();

        $category3 = new Category();
        $category3->name = 'BEST SELLER';
        $category3->makeRoot();

        $category4 = new Category();
        $category4->name = 'TOP SELLER';
        $category4->makeRoot();

        $sup = new Supplier;
        $sup->save();

        $s = new User;
        $s->role = User::SUPPLIER;
        $s->username = 'fournisseur';
        $s->password_hash = '123456';
        $s->email = 'supplier1@test.dz';
        $s->confirm = true;
        $s->status = User::STATUS_ACTIVE;
        if (!$s->createUser()) {
            echo "error\n";
            var_dump($s->supplier);
            die();
        }

        $p = new Product();
        $p->name = 'produit 1';
        $p->category_id = $category->id;
        $p->supplier_id = $s->supplier->id;
        $p->price = 1500;
        $p->quantity = 100;
        $p->marketer_bonus = 150;
        $p->save();

        $p = new Product();
        $p->name = 'produit 2';
        $p->category_id = $category->id;
        $p->supplier_id = $s->supplier->id;
        $p->price = 1500;
        $p->quantity = 100;
        $p->marketer_bonus = 150;
        $p->save();

        $p = new Product();
        $p->name = 'produit 3';
        $p->category_id = $category->id;
        $p->supplier_id = $s->supplier->id;
        $p->price = 1500;
        $p->quantity = 100;
        $p->marketer_bonus = 150;
        $p->save();

        $s = new User;
        $s->role = User::MARKETER;
        $s->username = 'marketer';
        $s->password_hash = '123456';
        $s->email = 'marketer@test.dz';
        $s->confirm = true;
        $s->status = User::STATUS_ACTIVE;
        $s->_app = 'backend';
        $s->createUser();
    }

    public function actionPayment()
    {
        $model = new Payment();
        $model->name = 'Paiement à la livraison';
        $model->status = Payment::STATUS_ACTIVE;
        $model->save();

        $model = new Payment();
        $model->name = 'Paiement via virement CCP';
        $model->status = Payment::STATUS_ACTIVE;
        $model->save();
    }

    public function actionTree()
    {
        \common\models\Ville::createTree();
    }
}
