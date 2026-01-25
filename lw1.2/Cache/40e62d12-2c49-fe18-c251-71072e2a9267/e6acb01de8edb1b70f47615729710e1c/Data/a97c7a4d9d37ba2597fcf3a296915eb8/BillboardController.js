"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RotationAxis = void 0;
const WorldCameraFinderProvider_1 = require("../../../Providers/CameraProvider/WorldCameraFinderProvider");
const SceneObjectUtils_1 = require("../../../Utils/SceneObjectUtils");
const InteractableManipulation_1 = require("../InteractableManipulation/InteractableManipulation");
const BillboardRotationCalculator_1 = require("./BillboardRotationCalculator");
var RotationAxis;
(function (RotationAxis) {
    RotationAxis[RotationAxis["X"] = 0] = "X";
    RotationAxis[RotationAxis["Y"] = 1] = "Y";
    RotationAxis[RotationAxis["Z"] = 2] = "Z";
})(RotationAxis || (exports.RotationAxis = RotationAxis = {}));
const rotationAxes = [RotationAxis.X, RotationAxis.Y, RotationAxis.Z];
const VEC_UP = vec3.up();
const VEC_DOWN = vec3.down();
class BillboardController {
    constructor(config) {
        var _a, _b, _c, _d, _e, _f, _g, _h, _j, _k, _l, _m;
        this.worldCameraProvider = WorldCameraFinderProvider_1.default.getInstance();
        // The target will rotate according to the camera's position for X/Y-axes rotation, camera's rotation for Z-axis rotation.
        this.cameraTransform = this.worldCameraProvider.getTransform();
        // We wait until the first update to set the rotation due to an inaccuracy of transforms on first frame.
        this.firstUpdate = true;
        this.manipulationComponent = null;
        this.pivotPoint = vec3.zero();
        this.pivotingInteractor = null;
        this.target = config.target;
        this._targetTransform = this.target.getTransform();
        this.manipulationComponent = this.findInteractableManipulation(this.target);
        // Set up the rotation calculators to rotate along the axes with specific behavior.
        this.xAxisCalculator = new BillboardRotationCalculator_1.default({
            axis: RotationAxis.X,
            axisEnabled: config.xAxisEnabled,
            axisBufferRadians: MathUtils.DegToRad * ((_b = (_a = config.axisBufferDegrees) === null || _a === void 0 ? void 0 : _a.x) !== null && _b !== void 0 ? _b : 0),
            axisEasing: (_d = (_c = config.axisEasing) === null || _c === void 0 ? void 0 : _c.x) !== null && _d !== void 0 ? _d : 1
        });
        this.yAxisCalculator = new BillboardRotationCalculator_1.default({
            axis: RotationAxis.Y,
            axisEnabled: config.yAxisEnabled,
            axisBufferRadians: MathUtils.DegToRad * ((_f = (_e = config.axisBufferDegrees) === null || _e === void 0 ? void 0 : _e.y) !== null && _f !== void 0 ? _f : 0),
            axisEasing: (_h = (_g = config.axisEasing) === null || _g === void 0 ? void 0 : _g.y) !== null && _h !== void 0 ? _h : 1
        });
        this.zAxisCalculator = new BillboardRotationCalculator_1.default({
            axis: RotationAxis.Z,
            axisEnabled: config.zAxisEnabled,
            axisBufferRadians: MathUtils.DegToRad * ((_k = (_j = config.axisBufferDegrees) === null || _j === void 0 ? void 0 : _j.z) !== null && _k !== void 0 ? _k : 0),
            axisEasing: (_m = (_l = config.axisEasing) === null || _l === void 0 ? void 0 : _l.z) !== null && _m !== void 0 ? _m : 1
        });
        this.updateEvent = config.script.createEvent("UpdateEvent");
        this.updateEvent.bind(this.onUpdate.bind(this));
    }
    enableAxisRotation(axis, enabled) {
        let axisCalculator;
        switch (axis) {
            case RotationAxis.X:
                axisCalculator = this.xAxisCalculator;
                break;
            case RotationAxis.Y:
                axisCalculator = this.yAxisCalculator;
                break;
            case RotationAxis.Z:
                axisCalculator = this.zAxisCalculator;
                break;
        }
        axisCalculator.axisEnabled = enabled;
    }
    get targetTransform() {
        return this._targetTransform;
    }
    get axisEasing() {
        return new vec3(this.xAxisCalculator.axisEasing, this.yAxisCalculator.axisEasing, this.zAxisCalculator.axisEasing);
    }
    set axisEasing(easing) {
        this.xAxisCalculator.axisEasing = easing.x;
        this.yAxisCalculator.axisEasing = easing.y;
        this.zAxisCalculator.axisEasing = easing.z;
    }
    get axisBufferDegrees() {
        return new vec3(MathUtils.RadToDeg * this.xAxisCalculator.axisBufferRadians, MathUtils.RadToDeg * this.yAxisCalculator.axisBufferRadians, MathUtils.RadToDeg * this.zAxisCalculator.axisBufferRadians);
    }
    set axisBufferDegrees(bufferDegrees) {
        this.xAxisCalculator.axisBufferRadians = MathUtils.DegToRad * bufferDegrees.x;
        this.yAxisCalculator.axisBufferRadians = MathUtils.DegToRad * bufferDegrees.y;
        this.zAxisCalculator.axisBufferRadians = MathUtils.DegToRad * bufferDegrees.z;
    }
    /**
     * Set the pivot point and pivoting Interactor to control the Billboard's pivot axis.
     * To turn off pivoting about a point, reset the pivot point to vec3.zero()
     * @param pivotPoint - the pivot point to billboard the target about in local space.
     * @param interactor - the pivoting Interactor.
     */
    setPivot(pivotPoint, interactor) {
        var _a, _b;
        this.pivotPoint = pivotPoint;
        this.pivotingInteractor = interactor;
        this.manipulationComponent = this.findInteractableManipulation((_b = (_a = this.pivotingInteractor.currentInteractable) === null || _a === void 0 ? void 0 : _a.sceneObject) !== null && _b !== void 0 ? _b : null);
    }
    // The following functions aid with getting unit vectors relative to the target's current rotation.
    getForwardVector() {
        return this.targetTransform.forward;
    }
    getUpVector() {
        return this.targetTransform.up;
    }
    getRightVector() {
        return this.targetTransform.right;
    }
    // Returns a unit vector aligned with the line from the target's center to the camera for X/Y-axes rotation.
    getTargetToCameraVector() {
        return this.cameraTransform.getWorldPosition().sub(this.targetTransform.getWorldPosition()).normalize();
    }
    // Returns the up vector of a camera for Z-axis rotation.
    getCameraUpVector() {
        return this.cameraTransform.up;
    }
    // Rotates the target about each enabled axis separately.
    onUpdate() {
        if (this.firstUpdate) {
            this.firstUpdate = false;
            this.resetRotation();
            return;
        }
        for (const axis of rotationAxes) {
            let rotationQuaternion;
            switch (axis) {
                case RotationAxis.X:
                    rotationQuaternion = this.xAxisCalculator.getRotation(this.getRightVector(), this.getForwardVector(), this.getTargetToCameraVector(), this.getUpVector());
                    break;
                case RotationAxis.Y:
                    {
                        let upVector;
                        if (this.getUpVector().dot(VEC_DOWN) > BillboardRotationCalculator_1.ALMOST_ONE) {
                            upVector = VEC_DOWN;
                        }
                        else {
                            upVector = VEC_UP;
                        }
                        rotationQuaternion = this.yAxisCalculator.getRotation(upVector, this.getForwardVector(), this.getTargetToCameraVector(), this.getRightVector().uniformScale(-1));
                    }
                    break;
                case RotationAxis.Z:
                    rotationQuaternion = this.zAxisCalculator.getRotation(this.getForwardVector(), this.getUpVector(), this.getCameraUpVector(), this.getRightVector());
                    break;
                default:
                    throw new Error(`Invalid axis: ${axis}`);
            }
            // If the pivot point (in local space) is not the origin of the target, modify the position as well.
            if (!this.pivotPoint.equal(vec3.zero())) {
                const worldPivotPoint = this.targetTransform.getWorldTransform().multiplyPoint(this.pivotPoint);
                const v = this.targetTransform.getWorldPosition().sub(worldPivotPoint);
                const rotatedV = rotationQuaternion.multiplyVec3(v);
                const position = rotatedV.add(worldPivotPoint);
                this.targetTransform.setWorldPosition(position);
            }
            this.targetTransform.setWorldRotation(rotationQuaternion.multiply(this.targetTransform.getWorldRotation()));
            // To help InteractableManipulation ensure 1:1 movement with the initial trigger point, update the transform.
            if (this.manipulationComponent !== null) {
                this.manipulationComponent.updateStartTransform();
            }
        }
    }
    findInteractableManipulation(object) {
        if (!object) {
            return null;
        }
        const interactableManipulationTypeName = InteractableManipulation_1.InteractableManipulation.getTypeName();
        const component = object.getComponent(interactableManipulationTypeName);
        if (component) {
            return component;
        }
        return (0, SceneObjectUtils_1.findComponentInParents)(object, interactableManipulationTypeName, 10);
    }
    /**
     * Resets the pivot point to billboard the target about its own origin. Recommended to use after finishing
     * some spatial interaction that sets the pivotPoint of this component manually.
     */
    resetPivotPoint() {
        this.pivotPoint = vec3.zero();
        this.pivotingInteractor = null;
        this.manipulationComponent = null;
    }
    resetRotation() {
        for (const axis of rotationAxes) {
            let rotationQuaternion;
            switch (axis) {
                case RotationAxis.X:
                    rotationQuaternion = this.xAxisCalculator.resetRotation(this.getRightVector(), this.getForwardVector(), this.getTargetToCameraVector(), this.getUpVector());
                    break;
                case RotationAxis.Y:
                    {
                        let upVector;
                        if (this.getUpVector().dot(VEC_DOWN) > BillboardRotationCalculator_1.ALMOST_ONE) {
                            upVector = VEC_DOWN;
                        }
                        else {
                            upVector = VEC_UP;
                        }
                        rotationQuaternion = this.yAxisCalculator.resetRotation(upVector, this.getForwardVector(), this.getTargetToCameraVector(), this.getRightVector().uniformScale(-1));
                    }
                    break;
                case RotationAxis.Z:
                    rotationQuaternion = this.zAxisCalculator.resetRotation(this.getForwardVector(), this.getUpVector(), this.getCameraUpVector(), this.getRightVector());
                    break;
                default:
                    throw new Error(`Invalid axis: ${axis}`);
            }
            this.targetTransform.setWorldRotation(rotationQuaternion.multiply(this.targetTransform.getWorldRotation()));
        }
    }
}
exports.default = BillboardController;
//# sourceMappingURL=BillboardController.js.map